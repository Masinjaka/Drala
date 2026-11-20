// Renders ad.html frame by frame, then encodes an MP4 with ffmpeg.
// node store-assets/video/render-ad.mjs [--stills 1,5.5,...] [--fps 30]
import { execFileSync } from 'node:child_process';
import fs from 'node:fs';
import path from 'node:path';
import { pathToFileURL, fileURLToPath } from 'node:url';

const SKILL = path.join(process.env.HOME, '.claude/skills/store-screenshot-designer/rendering/browser.mjs');
const { launchBrowser } = await import(SKILL);
const here = path.dirname(fileURLToPath(import.meta.url));
const args = process.argv.slice(2);
const opt = (k, d) => { const i = args.indexOf(k); return i >= 0 ? args[i + 1] : d; };
const fps = Number(opt('--fps', 30));
const stills = opt('--stills', '');
const out = opt('--out', path.join(here, 'build'));

const browser = await launchBrowser();
const page = await browser.newPage({ viewport: { width: 1080, height: 1920 }, deviceScaleFactor: 1 });
await page.goto(pathToFileURL(path.join(here, 'ad.html')).href);
await page.evaluate(() => window.render(0));
const duration = await page.evaluate(() => window.DURATION);
const stage = page.locator('#stage');

if (stills) {
  fs.mkdirSync(out, { recursive: true });
  for (const t of stills.split(',').map(Number)) {
    await page.evaluate((x) => window.render(x), t);
    await stage.screenshot({ path: path.join(out, `still-${t}.png`) });
  }
} else {
  const frames = path.join(out, 'frames');
  fs.rmSync(frames, { recursive: true, force: true });
  fs.mkdirSync(frames, { recursive: true });
  const n = Math.round(duration * fps);
  for (let i = 0; i < n; i++) {
    await page.evaluate((x) => window.render(x), i / fps);
    await stage.screenshot({ path: path.join(frames, `${String(i).padStart(5, '0')}.jpg`), type: 'jpeg', quality: 94 });
  }
  const mp4 = path.join(out, 'drala-ad.mp4');
  execFileSync('ffmpeg', ['-y', '-loglevel', 'error', '-framerate', String(fps), '-i', path.join(frames, '%05d.jpg'),
    '-c:v', 'libx264', '-preset', 'slow', '-crf', '18', '-pix_fmt', 'yuv420p', '-movflags', '+faststart', mp4]);
  console.log(JSON.stringify({ frames: n, duration, mp4 }));
}
await browser.close();
