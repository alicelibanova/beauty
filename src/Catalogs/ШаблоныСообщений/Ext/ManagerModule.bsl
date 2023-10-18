﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// СтандартныеПодсистемы.УправлениеДоступом

// Параметры:
//   Ограничение - см. УправлениеДоступомПереопределяемый.ПриЗаполненииОграниченияДоступа.Ограничение.
//
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Автор)
	|	ИЛИ НЕ ТолькоДляАвтора";
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

// СтандартныеПодсистемы.ПодключаемыеКоманды

// Определяет список команд создания на основании.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//  Параметры - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.Параметры
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
КонецПроцедуры

// Для использования в процедуре ДобавитьКомандыСозданияНаОсновании других модулей менеджеров объектов.
// Добавляет в список команд создания на основании этот объект.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//
// Возвращаемое значение:
//  СтрокаТаблицыЗначений, Неопределено - описание добавленной команды.
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульСозданиеНаОсновании = ОбщегоНазначения.ОбщийМодуль("СозданиеНаОсновании");
		Команда = МодульСозданиеНаОсновании.ДобавитьКомандуСозданияНаОсновании(КомандыСозданияНаОсновании, Метаданные.Справочники.ШаблоныСообщений);
		Если Команда <> Неопределено Тогда
			Команда.ФункциональныеОпции = "ИспользоватьШаблоныСообщений";
		КонецЕсли;
		Возврат Команда;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)

	Если Параметры.Свойство("ВладелецШаблона") И ЗначениеЗаполнено(Параметры.ВладелецШаблона) Тогда
		Параметры.Вставить("ВладелецШаблона", Параметры.ВладелецШаблона);
		Если Параметры.Свойство("Новый") И Параметры.Новый <> Истина Тогда
			Параметры.Вставить("Ключ", ШаблоныСообщенийСлужебный.ШаблонПоВладельцу(Параметры.ВладелецШаблона));
		КонецЕсли;
		ВыбраннаяФорма = "Справочник.ШаблоныСообщений.ФормаОбъекта";
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныйПрограммныйИнтерфейс

// Смотри также ОбновлениеИнформационнойБазыПереопределяемый.ПриНастройкеНачальногоЗаполненияЭлементов
// 
// Параметры:
//  Настройки - см. ОбновлениеИнформационнойБазыСлужебный.НастройкиЗаполненияЭлементов
//
Процедура ПриНастройкеНачальногоЗаполненияЭлементов(Настройки) Экспорт
	
	ШаблоныСообщенийПереопределяемый.ПриНастройкеНачальногоЗаполненияЭлементов(Настройки);
	
	Настройки.ПриНачальномЗаполненииЭлемента = Истина;
	Настройки.ИмяКлючевогоРеквизита          = "Ссылка";
	
КонецПроцедуры

// Смотри также ОбновлениеИнформационнойБазыПереопределяемый.ПриНачальномЗаполненииЭлементов
// 
// Параметры:
//   КодыЯзыков - см. ОбновлениеИнформационнойБазыПереопределяемый.ПриНачальномЗаполненииЭлементов.КодыЯзыков
//   Элементы   - см. ОбновлениеИнформационнойБазыПереопределяемый.ПриНачальномЗаполненииЭлементов.Элементы
//   ТабличныеЧасти - см. ОбновлениеИнформационнойБазыПереопределяемый.ПриНачальномЗаполненииЭлементов.ТабличныеЧасти
//
Процедура ПриНачальномЗаполненииЭлементов(КодыЯзыков, Элементы, ТабличныеЧасти) Экспорт
	
	ШаблоныСообщенийПереопределяемый.ПриНачальномЗаполненииЭлементов(КодыЯзыков, Элементы, ТабличныеЧасти);
	
КонецПроцедуры

// Смотри также ОбновлениеИнформационнойБазыПереопределяемый.ПриНастройкеНачальногоЗаполненияЭлементов
//
// Параметры:
//  Объект                  - СправочникОбъект.ВидыКонтактнойИнформации - заполняемый объект.
//  Данные                  - СтрокаТаблицыЗначений - данные заполнения объекта.
//  ДополнительныеПараметры - Структура:
//   * ПредопределенныеДанные - ТаблицаЗначений - данные заполненные в процедуре ПриНачальномЗаполненииЭлементов.
//
Процедура ПриНачальномЗаполненииЭлемента(Объект, Данные, ДополнительныеПараметры) Экспорт
	
	ШаблоныСообщенийПереопределяемый.ПриНачальномЗаполненииЭлемента(Объект, Данные, ДополнительныеПараметры);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

// Регистрирует к обработке шаблоны сообщений.
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ШаблоныСообщений.Ссылка КАК Ссылка,
		|	ШаблоныСообщений.ПолноеИмяТипаПараметраВводаНаОсновании КАК ПолноеИмяТипаПараметраВводаНаОсновании
		|ИЗ
		|	Справочник.ШаблоныСообщений КАК ШаблоныСообщений
		|ГДЕ
		|	ШаблоныСообщений.ПредназначенДляВводаНаОсновании = ИСТИНА";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	ШаблоныКОбработке = РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Ссылка");
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, ШаблоныКОбработке);
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.КонтактнаяИнформация") Тогда
		МодульУправлениеКонтактнойИнформациейСлужебный = ОбщегоНазначения.ОбщийМодуль("УправлениеКонтактнойИнформациейСлужебный");
		Если МодульУправлениеКонтактнойИнформациейСлужебный.ВидыКонтактнойИнформацииОбновляются(Параметры.Очередь) Тогда
			Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, "Справочник.ШаблоныСообщений");
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки") Тогда
		МодульДополнительныеОтчетыИОбработки = ОбщегоНазначения.ОбщийМодуль("ДополнительныеОтчетыИОбработки");
		Если МодульДополнительныеОтчетыИОбработки.ДополнительныеОтчетыИОбработкиОбновляются(Параметры.Очередь) Тогда
			Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, "Справочник.ШаблоныСообщений");
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Шаблон = ОбновлениеИнформационнойБазы.ВыбратьСсылкиДляОбработки(Параметры.Очередь, "Справочник.ШаблоныСообщений");
	
	ПроблемныхОбъектов = 0;
	ОбъектовОбработано = 0;
	
	Пока Шаблон.Следующий() Цикл
		
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("Справочник.ШаблоныСообщений");
		ЭлементБлокировки.УстановитьЗначение("Ссылка", Шаблон.Ссылка);
		
		НачатьТранзакцию();
		Попытка
			
			Блокировка.Заблокировать();
			
			ШаблонОбъект = Шаблон.Ссылка.ПолучитьОбъект();
			Если ШаблонОбъект = Неопределено Тогда // объект может быть уже удален в других сеансах
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Шаблон.Ссылка);
				ОбъектовОбработано = ОбъектовОбработано + 1;
				ЗафиксироватьТранзакцию();
				Продолжить;
			КонецЕсли;
			
			ПараметрыШаблона = ШаблоныСообщенийСлужебный.ПараметрыШаблона(Шаблон.Ссылка);
			СведенияОШаблоне = ШаблоныСообщенийСлужебный.СведенияОШаблоне(ПараметрыШаблона);
			
			МетаданныеОбъект = ОбщегоНазначения.ОбъектМетаданныхПоПолномуИмени(ПараметрыШаблона.ПолноеИмяТипаНазначения);
			
			Если МетаданныеОбъект = Неопределено Тогда
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Шаблон.Ссылка);
				ОбъектовОбработано = ОбъектовОбработано + 1;
				ЗафиксироватьТранзакцию();
				Продолжить;
			КонецЕсли;
			
			ПараметрыДляЗамены = Новый Соответствие;
			Префикс = МетаданныеОбъект.Имя + ".";
			
			ИдентификаторыФормулЗаполнены = Истина;
			
			Для каждого РеквизитОбъектаНазначения Из МетаданныеОбъект.Реквизиты Цикл
				Если РеквизитОбъектаНазначения.Тип.Типы().Количество() = 1 Тогда
					ТипОбъекта = Метаданные.НайтиПоТипу(РеквизитОбъектаНазначения.Тип.Типы()[0]);
					Если ТипОбъекта <> Неопределено И СтрНачинаетсяС(ТипОбъекта.ПолноеИмя(), "Справочник") Тогда
						МетаданныеВложенногоОбъект = Метаданные.НайтиПоПолномуИмени(ТипОбъекта.ПолноеИмя());
						ВложенныйПредмет = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ТипОбъекта.ПолноеИмя()).ПустаяСсылка();
						ПодготовитьПараметрыСвойствоИКИ(МетаданныеВложенногоОбъект, ВложенныйПредмет, 
							ПараметрыДляЗамены, Префикс + РеквизитОбъектаНазначения.Имя + ".", ИдентификаторыФормулЗаполнены);
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
			
			Предмет = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ПараметрыШаблона.ПолноеИмяТипаНазначения).ПустаяСсылка();
			ПодготовитьПараметрыСвойствоИКИ(МетаданныеОбъект, Предмет, ПараметрыДляЗамены, Префикс, ИдентификаторыФормулЗаполнены);
			
			СформироватьПараметрыДляЗамены(СведенияОШаблоне.ОбщиеРеквизиты.Строки, ПараметрыДляЗамены, "", ИдентификаторыФормулЗаполнены);
			Если ИдентификаторыФормулЗаполнены Тогда
			
				Если ПараметрыШаблона.ТипШаблона = "Письмо" Тогда
					
					Для каждого РеквизитДляЗамены Из ПараметрыДляЗамены Цикл
						ШаблонОбъект.ТемаПисьма = СтрЗаменить(ШаблонОбъект.ТемаПисьма, РеквизитДляЗамены.Ключ, РеквизитДляЗамены.Значение);
						ШаблонОбъект.ТекстШаблонаПисьмаHTML = СтрЗаменить(ШаблонОбъект.ТекстШаблонаПисьмаHTML, РеквизитДляЗамены.Ключ, РеквизитДляЗамены.Значение);
						ШаблонОбъект.ТекстШаблонаПисьма = СтрЗаменить(ШаблонОбъект.ТекстШаблонаПисьма, РеквизитДляЗамены.Ключ, РеквизитДляЗамены.Значение);
					КонецЦикла;
					
				Иначе
					
					Для каждого РеквизитДляЗамены Из ПараметрыДляЗамены Цикл
						ШаблонОбъект.ТекстШаблонаSMS = СтрЗаменить(ШаблонОбъект.ТекстШаблонаSMS, РеквизитДляЗамены.Ключ, РеквизитДляЗамены.Значение);
					КонецЦикла;
					
				КонецЕсли;
				
				ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ШаблонОбъект);
				
				ОбъектовОбработано = ОбъектовОбработано + 1;
			Иначе
				ПроблемныхОбъектов = ПроблемныхОбъектов + 1;
			КонецЕсли;
			
			ЗафиксироватьТранзакцию();
		Исключение
			// Если не удалось обработать шаблон сообщения, повторяем попытку снова.
			ОтменитьТранзакцию();
			ПроблемныхОбъектов = ПроблемныхОбъектов + 1;
			
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось обработать шаблон сообщения %1 по причине: 
					|%2';
					|en = 'Couldn''t process message template %1. Reason:
					|%2'"),
				Шаблон.Ссылка, ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Предупреждение,
				Метаданные.Справочники.ШаблоныСообщений, Шаблон.Ссылка, ТекстСообщения);
		КонецПопытки;
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, "Справочник.ШаблоныСообщений");
	
	Если ОбъектовОбработано = 0 И ПроблемныхОбъектов <> 0 Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось обработать некоторые шаблоны сообщений (пропущены): %1';
				|en = 'Couldn''t process (skipped) some message templates: %1'"), 
			ПроблемныхОбъектов);
		ВызватьИсключение ТекстСообщения;
	Иначе
		ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Информация,
			Метаданные.Справочники.ШаблоныСообщений,,
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Процедура обновления обработала очередную порцию шаблонов сообщений: %1';
																		|en = 'A batch of message templates is processed: %1'"),
				ОбъектовОбработано));
	КонецЕсли;
	
КонецПроцедуры

Процедура СформироватьПараметрыДляЗамены(Строки, РеквизитыДляЗамены, Префикс, ИдентификаторыФормулЗаполнены)
	
	Для каждого РеквизитОбъектаНазначения Из Строки Цикл
			
		Если РеквизитОбъектаНазначения.Тип.Типы().Количество() = 1 Тогда
			ТипОбъекта = Метаданные.НайтиПоТипу(РеквизитОбъектаНазначения.Тип.Типы()[0]);
			Если ТипОбъекта <> Неопределено И СтрНачинаетсяС(ТипОбъекта.ПолноеИмя(), "Справочник") Тогда
				МетаданныеВложенногоОбъект = Метаданные.НайтиПоПолномуИмени(ТипОбъекта.ПолноеИмя());
				ВложенныйПредмет = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ТипОбъекта.ПолноеИмя()).ПустаяСсылка();
				ПодготовитьПараметрыСвойствоИКИ(МетаданныеВложенногоОбъект, ВложенныйПредмет,
					РеквизитыДляЗамены, Префикс + РеквизитОбъектаНазначения.Имя + ".", ИдентификаторыФормулЗаполнены);
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		
		Если РеквизитОбъектаНазначения.Строки.Количество() > 0 Тогда
			СформироватьПараметрыДляЗамены(РеквизитОбъектаНазначения.Строки, РеквизитыДляЗамены, Префикс, ИдентификаторыФормулЗаполнены);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПодготовитьПараметрыСвойствоИКИ(Знач МетаданныеОбъект, Знач Предмет, Знач РеквизитыДляЗамены, Префикс, ИдентификаторыФормулЗаполнены)
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.КонтактнаяИнформация") Тогда
		МодульУправлениеКонтактнойИнформацией = ОбщегоНазначения.ОбщийМодуль("УправлениеКонтактнойИнформацией");
		ВидыКонтактнойИнформацией = МодульУправлениеКонтактнойИнформацией.ВидыКонтактнойИнформацииОбъекта(Предмет);
		Если ВидыКонтактнойИнформацией.Количество() > 0 Тогда
			Для каждого ВидКонтактнойИнформацией Из ВидыКонтактнойИнформацией Цикл
				
				Если ПустаяСтрока(ВидКонтактнойИнформацией.ИдентификаторДляФормул) 
					И Не ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидКонтактнойИнформацией.Ссылка, "ЭтоГруппа")  Тогда
					ИдентификаторыФормулЗаполнены = Ложь;
					Возврат;
				КонецЕсли;
				РеквизитыДляЗамены.Вставить("[" + Префикс + ВидКонтактнойИнформацией.Наименование + "]", "[" + Префикс + "~КИ." + ВидКонтактнойИнформацией.ИдентификаторДляФормул + "]");
				
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
	Свойства = Новый Массив;
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствами = ОбщегоНазначения.ОбщийМодуль("УправлениеСвойствами");
		ПолучатьДопСведения = МодульУправлениеСвойствами.ИспользоватьДопСведения(Предмет);
		ПолучатьДопРеквизиты = МодульУправлениеСвойствами.ИспользоватьДопРеквизиты(Предмет);
		
		Если ПолучатьДопРеквизиты Или ПолучатьДопСведения Тогда
			Свойства = МодульУправлениеСвойствами.СвойстваОбъекта(Предмет, ПолучатьДопРеквизиты, ПолучатьДопСведения);
			Для каждого Свойство Из Свойства Цикл
				
				Если ПустаяСтрока(Свойство.ИдентификаторДляФормул) Тогда
						ИдентификаторыФормулЗаполнены = Ложь;
					Возврат;
					
				КонецЕсли;
				
				РеквизитыДляЗамены.Вставить("[" + Префикс + Свойство.Наименование + "]", "[" + Префикс + "~Свойство." + Свойство.ИдентификаторДляФормул + "]");
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецОбласти


#КонецЕсли
