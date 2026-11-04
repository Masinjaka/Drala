export async function measureFinancePhase<T>(
  phase: string,
  operation: () => PromiseLike<T>,
): Promise<T> {
  const started = performance.now();
  let succeeded = false;
  try {
    const result = await operation();
    succeeded = true;
    return result;
  } finally {
    // No prompt, financial data, credentials, or user identifiers in timing logs.
    console.info(JSON.stringify({
      event: "finance_phase",
      phase,
      duration_ms: Math.round(performance.now() - started),
      succeeded,
    }));
  }
}
