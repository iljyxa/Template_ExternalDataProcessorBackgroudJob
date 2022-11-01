
#Область ОписаниеПеременных

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	АдресРезультата = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
	Параметры.Свойство("ДополнительнаяОбработкаСсылка", ДополнительнаяОбработкаСсылка);
	ЭтоДополнительнаяОбработка = ЗначениеЗаполнено(ДополнительнаяОбработкаСсылка);

	Если НЕ ЭтоДополнительнаяОбработка Тогда
		ИспользуемоеИмяФайла = РеквизитФормыВЗначение("Объект").ИспользуемоеИмяФайла;
	КонецЕсли;	

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Код процедур и функций

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

// Код процедур и функций

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьВФоне(Команда)

	ОчиститьСообщения();
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыполнитьВФонеЗавершение", ЭтотОбъект);
	
	// TODO: Проверить параметры, изменить текст сообщения
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьПрогрессВыполнения = Истина;
	ПараметрыОжидания.ТекстСообщения = НСтр("ru = 'Выполняется фоновое задание...'");
	
	Если Не ЗначениеЗаполнено(АдресВнешнейОбработки) Тогда
		ДвоичныеДанные = Новый ДвоичныеДанные(ИспользуемоеИмяФайла);
		АдресВнешнейОбработки = ПоместитьВоВременноеХранилище(ДвоичныеДанные, УникальныйИдентификатор);
	КонецЕсли;
		
	РезультатДлительнойОперации = РезультатДлительнойОперации();
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(РезультатДлительнойОперации, ОписаниеОповещения, ПараметрыОжидания);	

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция РезультатДлительнойОперации()
	
	// TODO: Проверить параметры, изменить наименование фонового задания
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Наименование фонового задания'");
	ПараметрыВыполнения.ЗапуститьВФоне = Истина;
	ПараметрыВыполнения.Вставить("ИдентификаторФормы", УникальныйИдентификатор);
	
	// TODO: Указать параметры, которые будут переданы в параметр процедуры, выполняемой в фоне
	// При выполнении процедуры модуля объекта, реквизиты обработки будут пустыми т.к создается новый
	// экземпляр обработки, поэтому, при необходимости использования реквизитов обработки, их необходимо
	// явно передавать через ПараметрыПроцедуры, потом обрабатывать в процедуры модуля объекта, а затем
	// передавать в качестве результата и заполнять.
	ПараметрыПроцедуры = Неопределено;
	
	ПараметрыЗапускаПроцедуры = Новый Структура;
	ПараметрыЗапускаПроцедуры.Вставить("ДополнительнаяОбработкаСсылка", ДополнительнаяОбработкаСсылка);
	// TODO: Указать процедуру модуля объекта, выполняющуюся в фоне
	ПараметрыЗапускаПроцедуры.Вставить("ИмяМетода", "ОбработкаДанныхВФоне");
	ПараметрыЗапускаПроцедуры.Вставить("ЭтоВнешняяОбработка", Истина);
	ПараметрыЗапускаПроцедуры.Вставить("ПараметрыВыполнения", ПараметрыПроцедуры);
	
	Если НЕ ЭтоДополнительнаяОбработка Тогда
		//@skip-check missing-temporary-file-deletion
		ИмяВременногоФайлаОбработки = ПолучитьИмяВременногоФайла(".epf");
		ДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресВнешнейОбработки);
		ДвоичныеДанные.Записать(ИмяВременногоФайлаОбработки);
		ПараметрыПроцедуры.Вставить("ИмяОбработки", ИмяВременногоФайлаОбработки);
	КонецЕсли;	
	
	Возврат ДлительныеОперации.ВыполнитьПроцедуру(ПараметрыВыполнения,
												  "ДлительныеОперации.ВыполнитьПроцедуруМодуляОбъектаОбработки",
												  ПараметрыЗапускаПроцедуры,
												  АдресРезультата);
	
КонецФункции

&НаКлиенте
Процедура ВыполнитьВФонеЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	УдалитьВременныйФайл();
	
	Если Результат = Неопределено Тогда
		Возврат;
	ИначеЕсли Результат.Статус = "Выполнено" Тогда
		// TODO: Обработка результата выполнения
		ОбработатьРезультатВыполненияВФонеНаСервере();
	ИначеЕсли Результат.Статус = "Отменено" Тогда
		// TODO: Обработка отмены
	ИначеЕсли Результат.Статус = "Выполняется" Тогда
		// Такого быть не должно
	Иначе // Ошибка
		// TODO: Обработка ошибки
		ПоказатьПредупреждение(, Результат.КраткоеПредставлениеОшибки);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УдалитьВременныйФайл()

	Файл = Новый Файл(ИмяВременногоФайлаОбработки);
	Если Файл.Существует() Тогда
		УдалитьФайлы(ИмяВременногоФайлаОбработки);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьРезультатВыполненияВФонеНаСервере()
	
	РезультатВыполненияПроцедуры = ПолучитьИзВременногоХранилища(АдресРезультата);
	// TODO: Обработать результат выполнения
	
КонецПроцедуры

#КонецОбласти
