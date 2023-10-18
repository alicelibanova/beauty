﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Обновление информационной базы.

Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЭлектронныеПодписи.ПодписанныйОбъект КАК ПодписанныйОбъект,
	|	ЭлектронныеПодписи.ПорядковыйНомер КАК ПорядковыйНомер
	|ИЗ
	|	РегистрСведений.ЭлектронныеПодписи КАК ЭлектронныеПодписи
	|ГДЕ
	|	(ЭлектронныеПодписи.ИмяФайлаПодписи ПОДОБНО ""%\%"" СПЕЦСИМВОЛ ""~""
	|			ИЛИ ЭлектронныеПодписи.ИмяФайлаПодписи ПОДОБНО ""%/%"" СПЕЦСИМВОЛ ""~"")
	|	ИЛИ ЭлектронныеПодписи.ИдентификаторПодписи = &ПустойУникальныйИдентификатор";
	
	Запрос.УстановитьПараметр("ПустойУникальныйИдентификатор", Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000"));
	
	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметры.ЭтоНезависимыйРегистрСведений = Истина;
	ДополнительныеПараметры.ПолноеИмяРегистра = Метаданные.РегистрыСведений.ЭлектронныеПодписи.ПолноеИмя();
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Запрос.Выполнить().Выгрузить(), ДополнительныеПараметры);
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ОбработкаЗавершена = Истина;
	
	МетаданныеРегистра    = Метаданные.РегистрыСведений.ЭлектронныеПодписи;
	ПолноеИмяРегистра     = МетаданныеРегистра.ПолноеИмя();
	Выборка = ОбновлениеИнформационнойБазы.ВыбратьИзмеренияНезависимогоРегистраСведенийДляОбработки(
		Параметры.Очередь, ПолноеИмяРегистра);
	
	Обработано = 0;
	Проблемных = 0;
	
	Пока Выборка.Следующий() Цикл
		НаборЗаписей = РегистрыСведений.ЭлектронныеПодписи.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ПодписанныйОбъект.Установить(Выборка.ПодписанныйОбъект);
		НаборЗаписей.Отбор.ПорядковыйНомер.Установить(Выборка.ПорядковыйНомер);
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяРегистра);
		ЭлементБлокировки.УстановитьЗначение("ПодписанныйОбъект", Выборка.ПодписанныйОбъект);
		ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяРегистра);
		ЭлементБлокировки.УстановитьЗначение("ПорядковыйНомер", Выборка.ПорядковыйНомер);
		НачатьТранзакцию();
		Попытка
			Блокировка.Заблокировать();
			НаборЗаписей.Прочитать();
			Если НаборЗаписей.Количество() > 0 Тогда
				Запись = НаборЗаписей[0];
				ИмяФайлаПодписиБезПути = Неопределено;
				ЧастиИмени = СтрРазделить(Запись.ИмяФайлаПодписи, "\/", Ложь);
				Если ЧастиИмени.Количество() > 0 Тогда
					ИмяФайлаПодписиБезПути = ЧастиИмени[ЧастиИмени.ВГраница()];
				КонецЕсли;
				ЗаписатьНабор = Ложь;
				Если Не ЗначениеЗаполнено(Запись.ИдентификаторПодписи) Тогда
					Запись.ИдентификаторПодписи = Новый УникальныйИдентификатор;
					ЗаписатьНабор = Истина;
				КонецЕсли;
				Если ИмяФайлаПодписиБезПути <> Неопределено И Запись.ИмяФайлаПодписи <> ИмяФайлаПодписиБезПути Тогда
					Запись.ИмяФайлаПодписи = ИмяФайлаПодписиБезПути;
					ЗаписатьНабор = Истина;
				КонецЕсли;
				Если ЗаписатьНабор Тогда
					ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписей);
				КонецЕсли;
			КонецЕсли;
			ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(НаборЗаписей);
			Обработано = Обработано + 1;
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			Проблемных = Проблемных + 1;
			СвойстваКлюча = Новый Структура("ПодписанныйОбъект, ПорядковыйНомер",
				Выборка.ПодписанныйОбъект, Выборка.ПорядковыйНомер);
			КлючЗаписи = РегистрыСведений.ЭлектронныеПодписи.СоздатьКлючЗаписи(СвойстваКлюча);
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось обработать запись регистра %1 по причине:
					|%2';
					|en = 'Couldn''t process a ""%1"" register record. Reason:
					|%2'"),
				ПолучитьНавигационнуюСсылку(КлючЗаписи),
				ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
			ЗаписьЖурналаРегистрации(
				ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
				УровеньЖурналаРегистрации.Предупреждение,
				МетаданныеРегистра, , 
				ТекстСообщения);
		КонецПопытки;
	КонецЦикла;
	
	Если Не ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, ПолноеИмяРегистра) Тогда
		ОбработкаЗавершена = Ложь;
	КонецЕсли;
	
	ИмяПроцедуры = ПолноеИмяРегистра + "." + "ОбработатьДанныеДляПереходаНаНовуюВерсию";
	
	Если Обработано = 0 И Проблемных <> 0 Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Процедуре %1 не удалось обработать некоторые записи (пропущены): %2';
				|en = 'Procedure %1 failed to process (skipped) some records: %2.'"), 
			ИмяПроцедуры,
			Проблемных);
		ВызватьИсключение ТекстСообщения;
	КонецЕсли;
	
	ЗаписьЖурналаРегистрации(
		ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), 
		УровеньЖурналаРегистрации.Информация, МетаданныеРегистра, ,
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Процедура %1 обработала очередную порцию записей: %2';
				|en = 'Procedure %1 processed yet another batch of records: %2.'"),
			ИмяПроцедуры,
			Обработано));
	
	Параметры.ОбработкаЗавершена = ОбработкаЗавершена;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
