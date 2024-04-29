class_name InteractiveObject
extends CollisionObject2D
## Класс шаблона логики интерактивных объектов
##
## Хранит данные интерактивного сообщения, создает присутствие в физическом пространстве.

## Текст интерактивного сообщения. В будущем будет заменено на ключ перевода.
## @deprecated
@export var hint_message : String = ""
## Продолжительность интерактивного сообщения секундах.
@export_range(0, 10, 0.1, "or_greater", "suffix:секунд")
var hint_time : float = 0

## Использовать на [param user].
## Возвращает [param true], если использование успешно. В резульатат вмешивается метод [member _use_by]
func use_by(user : PlayerCharacter) -> bool:
	if user:
		if _use_by(user):
			return true
	return false

## Внутренняя реализация использования. Может быть переопределен.
## Возвращает [param true], если использование успешно.
func _use_by(_user : PlayerCharacter) -> bool:
	return true

## Возвращает текст собщения. В будущем будет возвращать текст перевода.
## @deprecated
func get_hint_message() -> String: # Добавить перевод
	return hint_message

## Возвращает продолжительность сообщения в секундах.
func get_hint_time() -> float:
	return hint_time
