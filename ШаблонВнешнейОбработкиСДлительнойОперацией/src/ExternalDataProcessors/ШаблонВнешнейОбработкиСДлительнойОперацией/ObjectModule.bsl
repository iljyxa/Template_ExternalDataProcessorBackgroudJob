
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

#КонецОбласти

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// Возвращает сведения о внешней обработке.
//
// Возвращаемое значение:
//   Структура - Подробнее см. ДополнительныеОтчетыИОбработки.СведенияОВнешнейОбработке().
//
Функция СведенияОВнешнейОбработке() Экспорт
	
	ПараметрыРегистрации = ДополнительныеОтчетыИОбработки.СведенияОВнешнейОбработке("2.2.2.1");
	ПараметрыРегистрации.Информация = "";
	ПараметрыРегистрации.Вид = ДополнительныеОтчетыИОбработкиКлиентСервер.ВидОбработкиДополнительнаяОбработка();
	ПараметрыРегистрации.Версия = "";
	ПараметрыРегистрации.БезопасныйРежим = Ложь;
	ПараметрыРегистрации.Наименование = Метаданные().Синоним;
	
	Команда = ПараметрыРегистрации.Команды.Добавить();
	Команда.Представление = ПараметрыРегистрации.Наименование;
	Команда.Идентификатор = ПараметрыРегистрации.Наименование;
	Команда.Использование = "ОткрытиеФормы";
	
	Возврат ПараметрыРегистрации;
	
КонецФункции

#КонецОбласти

Процедура ОбработкаДанныхВФоне(Параметры, АдресХранилищаРезультата) Экспорт
	
	ПрочитатьРеквизитыИТабличныеЧасти(Параметры);
	
	Результат = Новый Структура;
	
	// TODO: Реализовать обработку данных
	// ДлительныеОперации.СообщитьПрогресс(0, "Начало операции");
	// ДлительныеОперации.СообщитьПрогресс(100, "Завершение");
	
	ЗаписатьРеквизитыИТабличныеЧасти(Результат);
	ПоместитьВоВременноеХранилище(Результат, АдресХранилищаРезультата);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

// Код процедур и функций

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Код процедур и функций

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Выполняет загрузку реквизитов и табличных частей из параметров в обработку
// 
// Параметры:
//  Параметры - Структура - :
//   			 * _СлужебныеПараметры - Структура - Служебные параметры, созданные процедурой ЗаписатьРеквизитыИТабличныеЧасти:
//				  * Реквизиты - Структура -
//				  * ТабличныеЧасти - Структура -
Процедура ПрочитатьРеквизитыИТабличныеЧасти(Параметры) Экспорт
	
	Если ТипЗнч(Параметры) <> Тип("Структура") ИЛИ Не Параметры.Свойство("_СлужебныеПараметры") Тогда
		Возврат;
	КонецЕсли;
	
	СлужебныеПараметры = Параметры._СлужебныеПараметры;
	
	Для Каждого КлючИЗначение Из СлужебныеПараметры.Реквизиты Цикл
		ИмяРеквизита = КлючИЗначение.Ключ;
		ЗначениеРеквизита = КлючИЗначение.Значение;
		
		ЭтотОбъект[ИмяРеквизита] = ЗначениеРеквизита;
	КонецЦикла;	
	
	Для Каждого КлючИЗначение Из СлужебныеПараметры.ТабличныеЧасти Цикл
		ИмяТЧ = КлючИЗначение.Ключ;
		ТаблицаЗначений = КлючИЗначение.Значение;
		
		ЭтотОбъект[ИмяТЧ].Загрузить(ТаблицаЗначений);
	КонецЦикла;	
	
КонецПроцедуры

// Выполняет запись значений реквизитов и табличных частей обработки в параметры для передачи длительной операции
// 
// Параметры:
//  Параметры - Структура - Параметры
Процедура ЗаписатьРеквизитыИТабличныеЧасти(Параметры) Экспорт
	
	СлужебныеПараметры = Новый Структура;
	Реквизиты = Новый Структура;
	ТабличныеЧасти = Новый Структура;
	
	МетаданныеОбработки = Метаданные();
	
	Для Каждого ОбъектМетаданных Из МетаданныеОбработки.Реквизиты Цикл
		Реквизиты.Вставить(ОбъектМетаданных.Имя, ЭтотОбъект[ОбъектМетаданных.Имя]);
	КонецЦикла;
	
	Для Каждого ОбъектМетаданных Из МетаданныеОбработки.ТабличныеЧасти Цикл
		ТабличныеЧасти.Вставить(ОбъектМетаданных.Имя, ЭтотОбъект[ОбъектМетаданных.Имя].Выгрузить());
	КонецЦикла;
	
	СлужебныеПараметры.Вставить("Реквизиты", Реквизиты);
	СлужебныеПараметры.Вставить("ТабличныеЧасти", ТабличныеЧасти);
	
	Параметры.Вставить("_СлужебныеПараметры", СлужебныеПараметры);
	
КонецПроцедуры

#КонецОбласти

#Область Инициализация

#КонецОбласти

#КонецЕсли
