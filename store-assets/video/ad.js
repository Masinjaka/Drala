// Deterministic ad timeline: window.render(t) draws the frame at t seconds.
// Every app pixel comes from a real capture in ../captures/android/fr/.
const CAP = '../captures/android/fr/';
const C = { ink: '#0A0C10', emerald: '#059669', lime: '#D9F45A', mint: '#34D399' };
const clamp = (v, a = 0, b = 1) => Math.min(b, Math.max(a, v));
const prog = (t, a, d) => clamp((t - a) / d);
const outCubic = (x) => 1 - Math.pow(1 - x, 3);
const inOut = (x) => (x < 0.5 ? 4 * x * x * x : 1 - Math.pow(-2 * x + 2, 3) / 2);
const outBack = (x) => { const c = 1.9; return 1 + (c + 1) * Math.pow(x - 1, 3) + c * Math.pow(x - 1, 2); };

// A word or block that pops in: scale 1.5 → 1 with overshoot.
function pop(html, t, at, style, dur = 0.28) {
  const p = prog(t, at, dur);
  if (p <= 0) return '';
  const s = 1.5 - 0.5 * outBack(p);
  return `<div style="position:absolute;${style};opacity:${clamp(p * 3)};transform:scale(${s});transform-origin:left center">${html}</div>`;
}
// A line that slides up into place.
function rise(html, t, at, style, dur = 0.4) {
  const p = outCubic(prog(t, at, dur));
  if (p <= 0) return '';
  return `<div style="position:absolute;${style};opacity:${p};transform:translateY(${(1 - p) * 90}px)">${html}</div>`;
}
function phone(shots, x, y, s = 1, extra = '') {
  const imgs = shots.map(([f, o]) => `<img src="${CAP}${f}.png" style="opacity:${o}">`).join('');
  return `<div class="phone" style="left:${x}px;top:${y}px;transform:scale(${s}) ${extra};transform-origin:50% 0">
    <div class="screen">${imgs}<div class="hole"></div></div></div>`;
}
// Enlarged region [rx, ry, rw, rh] (capture px, 1080×2400) of a real capture.
function crop(f, [rx, ry, rw, rh], x, y, w, r, transform = '') {
  const k = w / rw;
  return `<div class="crop" style="left:${x}px;top:${y}px;width:${w}px;height:${rh * k}px;border-radius:${r}px;overflow:hidden;transform:${transform}">
    <img src="${CAP}${f}.png" style="position:absolute;left:${-rx * k}px;top:${-ry * k}px;width:${1080 * k}px;height:${2400 * k}px"></div>`;
}
function head(t, kicker, caption, onGreen) {
  const em = onGreen ? `style="color:${C.ink}"` : '';
  const [a, b] = caption;
  return pop(`<span class="kicker" style="position:static;display:inline-block">${kicker}</span>`, t, 0.05, 'left:72px;top:110px')
    + rise(`<div class="caption" style="position:static">${a}</div>`, t, 0.12, 'left:72px;top:190px')
    + rise(`<div class="caption" style="position:static"><em ${em}>${b}</em></div>`, t, 0.24, 'left:72px;top:290px');
}
const bg = (c) => `<div style="position:absolute;inset:0;background:${c}"><div class="grid"></div></div>`;
const phoneIn = (t) => 1920 - (1920 - 470) * outCubic(prog(t, 0.15, 0.55));

const SCENES = [
  { d: 2.4, f: (t) => bg(C.ink) + ['Où', 'passe', 'votre', 'argent ?'].map((w, i) =>
      pop(`<div class="word" style="position:static;font-size:200px;color:${i === 3 ? C.lime : '#fff'}">${w}</div>`,
        t, 0.1 + i * 0.32, `left:80px;top:${500 + i * 215}px`)).join('') },
  { d: 1.9, f: (t) => {
      const p = outBack(prog(t, 0.05, 0.45));
      return bg(`radial-gradient(circle at 50% 42%, #0f5f45 0%, ${C.ink} 62%)`)
        + `<div class="logo" style="left:330px;top:560px;transform:scale(${0.2 + 0.8 * p}) rotate(${(1 - p) * -14}deg);opacity:${clamp(p * 2)}"></div>`
        + rise(`<span class="kicker" style="position:static;display:inline-block;font-size:46px">Suivi de budget avec IA</span>`, t, 0.55, 'left:0;right:0;top:1080px;text-align:center');
    } },
  { d: 4.7, f: (t) => {
      const shot = t < 1.5 ? 'ai-idle' : t < 3.0 ? 'ai-typed' : 'ai-typed-clean';
      const p = outBack(prog(t, 3.15, 0.4));
      return bg(C.emerald) + head(t, 'Saisie par IA', ['Une phrase,', 'c’est noté'], true)
        + phone([[shot, 1]], 220, phoneIn(t), 1 + 0.03 * prog(t, 0.7, 4))
        + (p > 0 ? crop('ai-typed-clean', [79, 1901, 922, 263], 90, 1420, 900, 44, `scale(${0.6 + 0.4 * p})`) : '')
        + flashAt(t, [1.5, 3.0]);
    } },
  { d: 3.2, f: (t) => {
      const p = outBack(prog(t, 0.9, 0.4));
      return bg(C.ink) + head(t, 'Bilan du mois', ['Votre mois', 'en un coup d’œil'])
        + phone([['stats', 1]], 220, phoneIn(t))
        + (p > 0 ? crop('stats-categories', [63, 913, 954, 475], 40, 1120, 860, 34, `scale(${0.55 + 0.45 * p}) rotate(-3deg)`) : '');
    } },
  { d: 2.8, f: (t) => {
      const p = outCubic(prog(t, 0.8, 0.5));
      return bg(C.emerald) + head(t, 'Scan de reçus', ['Scannez', 'vos reçus'], true)
        + phone([['ai-idle', 1]], 220, phoneIn(t))
        + (p > 0 ? crop('receipt-sheet', [0, 1560, 1080, 840], 60, 1260 + (1 - p) * 700, 820, 64, 'rotate(-2deg)') : '');
    } },
  { d: 2.8, f: (t) => {
      const p = outBack(prog(t, 0.8, 0.4));
      const shake = t > 1.3 && t < 1.7 ? Math.sin(t * 90) * 14 * (1.7 - t) / 0.4 : 0;
      return bg(C.ink) + head(t, 'Enveloppes', ['Un budget', 'par enveloppe'])
        + phone([['envelopes', 1]], 220, phoneIn(t))
        + (p > 0 ? crop('envelopes', [63, 934, 954, 375], 130, 1200, 880, 34, `translateX(${shake}px) scale(${0.55 + 0.45 * p}) rotate(3deg)`) : '');
    } },
  { d: 4.2, f: (t) => {
      const beats = [['wallets', 'Portefeuilles', 'Espèces, banque, mobile money'], ['category-editor', 'Catégories', 'Créez les vôtres'],
        ['home-eur', 'Multidevise', 'Ariary, euro, dollar…'], ['reminders', 'Rappels', 'Un rappel chaque jour']];
      const i = Math.min(3, Math.floor(t / 1.05)); const lt = t - i * 1.05; const [shot, word, sub] = beats[i];
      const green = i % 2 === 0;
      return bg(green ? C.emerald : C.ink)
        + pop(`<div class="word" style="position:static;font-size:136px">${word}</div>`, lt, 0, 'left:72px;top:130px', 0.22)
        + rise(`<div style="font-weight:700;font-size:50px;color:${green ? C.ink : C.mint}">${sub}</div>`, lt, 0.12, 'left:76px;top:300px', 0.3)
        + phone([[shot, 1]], 220, 470, 1.07 - 0.07 * outCubic(prog(lt, 0, 0.5)))
        + flashAt(lt, [0]);
    } },
  { d: 4.0, f: (t) => {
      const p = outBack(prog(t, 0.1, 0.45)); const pulse = 1 + 0.04 * Math.sin(Math.max(0, t - 1.6) * 7);
      return bg(C.emerald)
        + `<div class="logo" style="left:390px;top:330px;width:300px;height:300px;border-radius:66px;transform:scale(${0.2 + 0.8 * p});opacity:${clamp(p * 2)}"></div>`
        + rise(`<div class="caption" style="position:static;text-align:center;font-size:118px">Votre argent,</div>`, t, 0.45, 'left:0;right:0;top:760px')
        + rise(`<div class="caption" style="position:static;text-align:center;font-size:118px;color:${C.ink}">enfin clair</div>`, t, 0.6, 'left:0;right:0;top:885px')
        + rise(`<div style="text-align:center;font-weight:700;font-size:46px">Revenus · Dépenses · Enveloppes · IA</div>`, t, 0.85, 'left:0;right:0;top:1070px')
        + (t > 1.2 ? `<div class="pill" style="left:50%;top:1300px;transform:translateX(-50%) scale(${pulse * outBack(prog(t, 1.2, 0.35))})">Téléchargez Drala</div>` : '');
    } },
];
function flashAt(t, at) {
  const o = Math.max(0, ...at.map((a) => (t >= a && t < a + 0.14 ? 0.7 * (1 - (t - a) / 0.14) : 0)));
  return o ? `<div class="flash" style="opacity:${o}"></div>` : '';
}
let start = 0; for (const s of SCENES) { s.a = start; start += s.d; }
window.DURATION = start;
const W = 0.3; // whip-pan push between scenes
window.render = async (t) => {
  let html = '';
  SCENES.forEach((s, i) => {
    const first = i === 0, last = i === SCENES.length - 1;
    if (t < s.a - (first ? 0 : W / 2) || t >= s.a + s.d + (last ? 1 : W / 2)) return;
    let x = 0, blur = 0;
    if (!first && t < s.a + W / 2) { const e = prog(t, s.a - W / 2, W); x = (1 - inOut(e)) * 1080; blur = Math.sin(Math.PI * e) * 26; }
    if (!last && t > s.a + s.d - W / 2) { const e = prog(t, s.a + s.d - W / 2, W); x = -inOut(e) * 1080; blur = Math.sin(Math.PI * e) * 26; }
    html += `<div class="layer" style="width:1080px;height:1920px;overflow:hidden;transform:translateX(${x}px);filter:blur(${blur}px)">${s.f(Math.max(0, t - s.a))}</div>`;
  });
  document.getElementById('scene').innerHTML = html;
  document.getElementById('bar').style.width = `${(t / window.DURATION) * 1080}px`;
  await document.fonts.ready;
  await Promise.all([...document.images].map((im) => im.decode().catch(() => {})));
};
