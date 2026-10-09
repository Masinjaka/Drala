const reminders: Record<string, { title: string; body: string }> = {
  en: {
    title: "Daily reminder",
    body: "Remember to record your expenses or income today.",
  },
  fr: {
    title: "Rappel quotidien",
    body: "Pensez à saisir vos dépenses ou revenus aujourd'hui.",
  },
  mg: {
    title: "Fampahatsiahivana isan'andro",
    body: "Aza adino ny manoratra ny fandaniana na ny vola miditra androany.",
  },
  de: {
    title: "Tägliche Erinnerung",
    body: "Denke daran, heute deine Ausgaben oder Einnahmen einzutragen.",
  },
  es: {
    title: "Recordatorio diario",
    body: "Recuerda registrar tus gastos o ingresos de hoy.",
  },
  it: {
    title: "Promemoria quotidiano",
    body: "Ricorda di registrare le spese o le entrate di oggi.",
  },
};

export function reminderMessage(languageCode: string | null | undefined) {
  return reminders[languageCode ?? ""] ?? reminders.en;
}
