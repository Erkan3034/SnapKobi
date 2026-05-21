abstract final class EmailValidator {
	static bool isValid(String email) {
		final value = email.trim();
		if (value.isEmpty) return false;
		final regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
		return regex.hasMatch(value);
	}
}
