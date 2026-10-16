String postSignUpDestination({
  required bool hasSession,
  required bool completedGuestOnboarding,
}) {
  if (completedGuestOnboarding) return '/home';
  return hasSession ? '/onboarding' : '/login';
}
