abstract final class PhoneValidator {
	static bool isValid(String phone) {
		final value = phone.replaceAll(RegExp(r'\s+'), '');
		if (value.isEmpty) return false;
		final regex = RegExp(r'^\+?[0-9]{10,15}$');
		return regex.hasMatch(value);
	}
}
