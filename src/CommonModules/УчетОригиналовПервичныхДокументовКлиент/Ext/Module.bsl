﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Устанавливает состояние оригинала для выделенных документов. Вызывается через подсистему "Подключаемые команды".
//
//	Параметры:
//  Ссылка - ДокументСсылка - ссылка на документ.
//  Параметры -см. ПодключаемыеКоманды.ПараметрыВыполненияКоманды.
//
Процедура Подключаемый_УстановитьСостояниеОригинала(Ссылка, Параметры) Экспорт
	
	Если Не УчетОригиналовПервичныхДокументовВызовСервера.ПраваНаИзменениеСостояния() Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'У пользователя недостаточно прав на изменение состояния оригинала первичного документа';
										|en = 'The user has insufficient rights to change source document original state'"));
		Возврат;
	КонецЕсли;
	
	Список = Параметры.Источник;
	
	Если Список.ВыделенныеСтроки.Количество() = 0 Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Не выделено ни одного документа, для которого можно установить выбранное состояние';
										|en = 'No document, for which the selected state can be set, is selected'"));
		Возврат;
	КонецЕсли;

	Если Параметры.ОписаниеКоманды.Вид = "УстановкаСостоянияОригиналПолучен" Тогда
		ИмяСостояния = ПредопределенноеЗначение("Справочник.СостоянияОригиналовПервичныхДокументов.ОригиналПолучен");
	Иначе
		ИмяСостояния = Параметры.ОписаниеКоманды.Представление;
	КонецЕсли;

	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Список",Список);

	Если Параметры.ОписаниеКоманды.Идентификатор = "НастройкаСостояний" Тогда
		ОткрытьФормуНастройкиСостояний();
		Возврат;
	ИначеЕсли Параметры.ОписаниеКоманды.Вид = "УстановкаСостоянияОригиналПолучен" И Список.ВыделенныеСтроки.Количество() = 1 Тогда
		ДополнительныеПараметры.Вставить("ИмяСостояния", ИмяСостояния);
		УстановитьСостояниеОригиналаЗавершение(КодВозвратаДиалога.Да, ДополнительныеПараметры);
		Возврат;
	КонецЕсли;

	ДополнительныеПараметры.Вставить("ИмяСостояния", ИмяСостояния);
	
	Если Список.ВыделенныеСтроки.Количество() > 1 Тогда
		ТекстВопроса = НСтр("ru = 'У выделенных в списке документов будет установлено состояние оригинала ""%ИмяСостояния%"". Продолжить?';
							|en = 'The ""%ИмяСостояния%"" original state will be set for documents selected in the list. Continue?'");
		ТекстВопроса = СтрЗаменить(ТекстВопроса, "%ИмяСостояния%", ИмяСостояния);

		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить(КодВозвратаДиалога.Да,НСтр("ru = 'Установить';
													|en = 'Set'"));
		Кнопки.Добавить(КодВозвратаДиалога.Нет,НСтр("ru = 'Не устанавливать';
													|en = 'Do not set'"));

		ПоказатьВопрос(Новый ОписаниеОповещения("УстановитьСостояниеОригиналаЗавершение", ЭтотОбъект, ДополнительныеПараметры), ТекстВопроса, Кнопки);
	ИначеЕсли УчетОригиналовПервичныхДокументовВызовСервера.ЭтоОбъектУчета(Список.ТекущиеДанные.Ссылка) Тогда 
		УстановитьСостояниеОригиналаЗавершение(КодВозвратаДиалога.Да, ДополнительныеПараметры);
	Иначе
		ПоказатьПредупреждение(, НСтр("ru = 'Для данного документа учет оригиналов не ведется.';
										|en = 'Records of originals are not kept for this document.'"));
	КонецЕсли;
	
КонецПроцедуры

// Устанавливает состояние оригинала для выделенных документов. Вызывается без подключения подсистемы "Подключаемые команды".
//
//	Параметры:
//  Команда - Строка- имя выполняемой команды формы.
//  Форма - ФормаКлиентскогоПриложения - форма списка или документа.
//  Список - ТаблицаФормы - список формы, в котором будет происходить изменение состояния.
//
Процедура УстановитьСостояниеОригинала(Команда, Форма, Список) Экспорт
	
	Если Не УчетОригиналовПервичныхДокументовВызовСервера.ПраваНаИзменениеСостояния() Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'У пользователя недостаточно прав на изменение состояния оригинала первичного документа';
										|en = 'The user has insufficient rights to change source document original state'"));
		Возврат;
	КонецЕсли;

	Если Список.ВыделенныеСтроки.Количество() = 0 Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Не выделено ни одного документа, для которого можно установить выбранное состояние';
										|en = 'No document, for which the selected state can be set, is selected'"));
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Список",Список);
	
	Если Команда = "НастройкаСостояний" Тогда
		ОткрытьФормуНастройкиСостояний();
		Возврат;
	ИначеЕсли Команда = "УстановитьОригиналПолучен" И Список.ВыделенныеСтроки.Количество()= 1 Тогда
		ДополнительныеПараметры.Вставить("ИмяСостояния", ПредопределенноеЗначение("Справочник.СостоянияОригиналовПервичныхДокументов.ОригиналПолучен"));
		УстановитьСостояниеОригиналаЗавершение(КодВозвратаДиалога.Да, ДополнительныеПараметры);
		Возврат;
	КонецЕсли;

	НайденноеСостояние = Форма.Элементы.Найти(Команда);

	Если Не НайденноеСостояние = Неопределено Тогда
		ИмяСостояния = НайденноеСостояние.Заголовок;
	ИначеЕсли Команда = "УстановитьОригиналПолучен" Тогда
		ИмяСостояния = ПредопределенноеЗначение("Справочник.СостоянияОригиналовПервичныхДокументов.ОригиналПолучен");
	КонецЕсли;

	ДополнительныеПараметры.Вставить("ИмяСостояния", ИмяСостояния);
	
	Если Список.ВыделенныеСтроки.Количество() > 1 Тогда
		ТекстВопроса = НСтр("ru = 'У выделенных в списке документов будет установлено состояние оригинала ""%ИмяСостояния%"". Продолжить?';
							|en = 'The ""%ИмяСостояния%"" original state will be set for documents selected in the list. Continue?'");
		ТекстВопроса = СтрЗаменить(ТекстВопроса, "%ИмяСостояния%", ИмяСостояния);

		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Установить';
													|en = 'Set'"));
		Кнопки.Добавить(КодВозвратаДиалога.Нет, НСтр("ru = 'Не устанавливать';
													|en = 'Do not set'"));

		ПоказатьВопрос(Новый ОписаниеОповещения("УстановитьСостояниеОригиналаЗавершение", ЭтотОбъект, ДополнительныеПараметры), 
			ТекстВопроса, Кнопки);
	ИначеЕсли УчетОригиналовПервичныхДокументовВызовСервера.ЭтоОбъектУчета(Список.ТекущиеДанные.Ссылка) Тогда 
		УстановитьСостояниеОригиналаЗавершение(КодВозвратаДиалога.Да, ДополнительныеПараметры);
	Иначе
		ПоказатьПредупреждение(, НСтр("ru = 'Для данного документа учет оригиналов не ведется.';
										|en = 'Records of originals are not kept for this document.'"));
	КонецЕсли;
	
КонецПроцедуры

// Открывает на форме списка или документа выпадающие меню выбора состояния оригинала.
//
//	Параметры:
//  Форма - ФормаКлиентскогоПриложения:
//   * Объект - ДанныеФормыСтруктура, ДокументОбъект - основной реквизит формы.
//  Источник - ТаблицаФормы - список или декорация формы, у которого будет открыт выпадающий список.
//                            Если не задан, то элемент с именем "ДекорацияСостояниеОригинала".  
//
Процедура ОткрытьМенюВыбораСостояния(Знач Форма, Знач Источник = Неопределено) Экспорт 
		
	Если Не УчетОригиналовПервичныхДокументовВызовСервера.ПраваНаИзменениеСостояния() Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'У пользователя недостаточно прав на изменение состояния оригинала первичного документа';
										|en = 'The user has insufficient rights to change source document original state'"));
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(Источник) = Неопределено Тогда
		Источник = Форма.Элементы.Найти("ДекорацияСостояниеОригинала");
	КонецЕсли;
	
	Если ТипЗнч(Источник) = Тип("ТаблицаФормы") Тогда
		
		ДанныеЗаписи = Источник.ТекущиеДанные;
		НепроведенныеДокументы = ОбщегоНазначенияВызовСервера.ПроверитьПроведенностьДокументов(
			ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ДанныеЗаписи.Ссылка));
		Если НепроведенныеДокументы.Количество() = 1 Тогда
			ПоказатьПредупреждение(,НСтр("ru = 'Для выполнения команды предварительно проведите документ.';
										|en = 'To run the command, post the document first.'"));
			Возврат;
		КонецЕсли;
		
		МассивЗаписей = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ДанныеЗаписи);
		ОписаниеОповещения = Новый ОписаниеОповещения("ОткрытьМенюВыбораСостоянияЗавершение", ЭтотОбъект, МассивЗаписей);

		Если ДанныеЗаписи.ОбщееСостояние Или Не ЗначениеЗаполнено(ДанныеЗаписи.СостояниеОригиналаПервичногоДокумента) Тогда
			УточнитьПоПечатнымФормам = Форма.СписокВыбораСостоянийОригинала.НайтиПоЗначению("УточнитьПоПечатнымФормам");
			Если УточнитьПоПечатнымФормам = Неопределено Тогда
				Форма.СписокВыбораСостоянийОригинала.Добавить("УточнитьПоПечатнымФормам",
					НСтр("ru = 'Уточнить по печатным формам...';
						|en = 'Specify for print forms…'"),,
					БиблиотекаКартинок.УточнитьСостояниеОригиналаПервичногоДокументаПоПечатнымФормам);
			КонецЕсли;
			Форма.ПоказатьВыборИзМеню(ОписаниеОповещения, Форма.СписокВыбораСостоянийОригинала,
				Форма.Элементы.СостояниеОригиналаПервичногоДокумента);
		Иначе
			УточнитьПоПечатнымФормам = Форма.СписокВыбораСостоянийОригинала.НайтиПоЗначению("УточнитьПоПечатнымФормам");
			Если УточнитьПоПечатнымФормам <> Неопределено Тогда
				Форма.СписокВыбораСостоянийОригинала.Удалить(УточнитьПоПечатнымФормам);
			КонецЕсли;
			Форма.ПоказатьВыборИзМеню(ОписаниеОповещения, Форма.СписокВыбораСостоянийОригинала,
				Форма.Элементы.СостояниеОригиналаПервичногоДокумента);
		КонецЕсли;
	Иначе
		Если Форма.Объект.Ссылка.Пустая() Тогда
			ПоказатьПредупреждение(,НСтр("ru = 'Для выполнения команды предварительно проведите документ.';
										|en = 'To run the command, post the document first.'"));
			Возврат;
		КонецЕсли;
		НепроведенныеДокументы = ОбщегоНазначенияВызовСервера.ПроверитьПроведенностьДокументов(
			ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Форма.Объект.Ссылка));

		Если НепроведенныеДокументы.Количество() = 1 Тогда
			ПоказатьПредупреждение(,НСтр("ru = 'Для выполнения команды предварительно проведите документ.';
										|en = 'To run the command, post the document first.'"));
			Возврат;
		КонецЕсли;

		ДополнительныеПараметры = Новый Структура("Ссылка", Форма.Объект.Ссылка);
		ОписаниеОповещения = Новый ОписаниеОповещения("ОткрытьМенюВыбораСостоянияЗавершение", ЭтотОбъект,
			ДополнительныеПараметры);

		УточнитьПоПечатнымФормам = Форма.СписокВыбораСостоянийОригинала.НайтиПоЗначению("УточнитьПоПечатнымФормам");
		Если УточнитьПоПечатнымФормам = Неопределено Тогда
			Форма.СписокВыбораСостоянийОригинала.Добавить("УточнитьПоПечатнымФормам",
				НСтр("ru = 'Уточнить по печатным формам...';
					|en = 'Specify for print forms…'"),,
				БиблиотекаКартинок.УточнитьСостояниеОригиналаПервичногоДокументаПоПечатнымФормам);
		КонецЕсли;

		Форма.ПоказатьВыборИзМеню(ОписаниеОповещения, Форма.СписокВыбораСостоянийОригинала, Источник);
	КонецЕсли;

КонецПроцедуры

// Обработчик оповещения событий подсистемы "Учет оригиналов первичных документов" для формы документа.
//
//	Параметры:
//  ИмяСобытия - Строка - имя произошедшего события.
//  Форма - ФормаКлиентскогоПриложения - форма документа.
//
Процедура ОбработчикОповещенияФормаДокумента(ИмяСобытия, Форма) Экспорт           
		
	Если ИмяСобытия = "ИзменениеСостоянияОригиналаПервичногоДокумента" Тогда 
		СформироватьНадписьТекущегоСостоянияОригинала(Форма);
	ИначеЕсли ИмяСобытия = "ДобавлениеУдалениеСостоянияОригиналаПервичногоДокумента" Тогда			
		Форма.ОбновитьОтображениеДанных();	
	КонецЕсли;
		
КонецПроцедуры

// Обработчик оповещения событий подсистемы "Учет оригиналов первичных документов" для формы списка.
//
//	Параметры:
//  ИмяСобытия - Строка - имя произошедшего события.
//  Форма - ФормаКлиентскогоПриложения - форма списка документов.
//  Список - ТаблицаФормы - основной список формы.
//
Процедура ОбработчикОповещенияФормаСписка(ИмяСобытия, Форма, Список) Экспорт 
	
	Если ИмяСобытия = "ДобавлениеУдалениеСостоянияОригиналаПервичногоДокумента" Тогда
		СтруктураПоиска = Новый Структура;
 		СтруктураПоиска.Вставить("СписокВыбораСостоянийОригинала", Неопределено);
 		ЗаполнитьЗначенияСвойств(СтруктураПоиска, Форма);
 		Если СтруктураПоиска.СписокВыбораСостоянийОригинала<> Неопределено Тогда
			Форма.ОтключитьОбработчикОжидания("Подключаемый_ОбновитьКомандыСостоянияОригинала");
			Форма.ПодключитьОбработчикОжидания("Подключаемый_ОбновитьКомандыСостоянияОригинала", 0.2, Истина);
			УчетОригиналовПервичныхДокументовВызовСервера.ЗаполнитьСписокВыбораСостоянийОригинала(Форма.СписокВыбораСостоянийОригинала);
			Форма.ОбновитьОтображениеДанных();
		Иначе
			Возврат;
		КонецЕсли;
	ИначеЕсли ИмяСобытия = "ИзменениеСостоянияОригиналаПервичногоДокумента" Тогда
		Список.Обновить();
	КонецЕсли;

КонецПроцедуры

// Обработчик события "Выбор" списка.
//
//	Параметры:
//  ИмяПоля - Строка - наименование выбранного поля.
//  Форма - ФормаКлиентскогоПриложения - форма списка документов.
//  Список - ТаблицаФормы - основной список формы.
//  СтандартнаяОбработка - Булево - Истина, если в форме используется стандартная обработка события "Выбор"
//
Процедура СписокВыбор(ИмяПоля, Форма, Список, СтандартнаяОбработка) Экспорт 
	
	Если ИмяПоля = "СостояниеОригиналаПервичногоДокумента" Или ИмяПоля = "СостояниеОригиналПолучен" Тогда
		СтандартнаяОбработка = Ложь;
		Если Не УчетОригиналовПервичныхДокументовВызовСервера.ПраваНаИзменениеСостояния() Тогда
			ПоказатьПредупреждение(, НСтр("ru = 'У пользователя недостаточно прав на изменение состояния оригинала первичного документа';
											|en = 'The user has insufficient rights to change source document original state'"));
			Возврат;
		КонецЕсли;
			Если УчетОригиналовПервичныхДокументовВызовСервера.ЭтоОбъектУчета(Список.ТекущиеДанные.Ссылка) Тогда
			Если ИмяПоля = "СостояниеОригиналаПервичногоДокумента" Тогда
				ОткрытьМенюВыбораСостояния(Форма, Список);
			ИначеЕсли ИмяПоля = "СостояниеОригиналПолучен" Тогда
				УстановитьСостояниеОригинала("УстановитьОригиналПолучен", Форма, Список);
			КонецЕсли;
		Иначе
			ПоказатьПредупреждение(, НСтр("ru = 'Для данного документа учет оригиналов не ведется.';
											|en = 'Records of originals are not kept for this document.'"));
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Процедура обрабатывает действия по учету оригиналов после сканирования штрихкода документа.
//
//	Параметры:
//  Штрихкод - Строка - отсканированный штрихкод документа.
//  ИмяСобытия - Строка - имя события формы.
//
Процедура ОбработатьШтрихкод(Штрихкод, ИмяСобытия) Экспорт
	
	Если ИмяСобытия = "ScanData" Тогда
		Состояние(НСтр("ru = 'Выполняется установка состояния оригинала по штрихкоду...';
						|en = 'Setting original state by barcode…'"));
		УчетОригиналовПервичныхДокументовВызовСервера.ОбработатьШтрихкод(Штрихкод[0]);
	КонецЕсли;
	
КонецПроцедуры

// Процедура показывает пользователю оповещение об изменении состояний оригинала документа.
//
//	Параметры:
//  КоличествоОбработанных - Число - количество успешно обработанных документов.
//  ДокументСсылка - ДокументСсылка - ссылка на документ для обработки нажатия на оповещение пользователя 
//		в случае единичной установки состояния. Необязательный параметр.
//  ИмяСостояния - Строка - устанавливаемое состояние.
//
Процедура ОповеститьПользователяОбУстановкеСостояний(КоличествоОбработанных, ДокументСсылка = Неопределено, ИмяСостояния = Неопределено) Экспорт

	Если КоличествоОбработанных > 1 Тогда
		ТекстСообщения = НСтр("ru = 'Для всех выделенных в списке документов установлено состояние оригинала ""%ИмяСостояния%""';
								|en = 'The ""%ИмяСостояния%"" original state is set for all documents selected in the list'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ИмяСостояния%", ИмяСостояния);
		
		ТекстЗаголовка = НСтр("ru = 'Состояние оригинала ""%ИмяСостояния%"" установлено';
								|en = 'The ""%ИмяСостояния%"" original state is set'");
		ТекстЗаголовка = СтрЗаменить(ТекстЗаголовка, "%ИмяСостояния%", ИмяСостояния);

		ПоказатьОповещениеПользователя(ТекстЗаголовка,, ТекстСообщения, БиблиотекаКартинок.Информация32,СтатусОповещенияПользователя.Важное);
	Иначе
		ОписаниеОповещения = Новый ОписаниеОповещения("ОбработатьНажатиеНаОповещение",ЭтотОбъект,ДокументСсылка);
		ПоказатьОповещениеПользователя(НСтр("ru = 'Изменение состояния оригинала:';
											|en = 'Original state changed:'"),ОписаниеОповещения,ДокументСсылка,БиблиотекаКартинок.Информация32,СтатусОповещенияПользователя.Важное);
	КонецЕсли;

КонецПроцедуры

// Открывает форму списка справочника "СостоянияОригиналовПервичныхДокументов".
Процедура ОткрытьФормуНастройкиСостояний() Экспорт
	
	ОткрытьФорму("Справочник.СостоянияОригиналовПервичныхДокументов.ФормаСписка");

КонецПроцедуры

// Вызывается для записи состояний оригиналов печатных форм в регистр, после печати формы.
//
//	Параметры:
//  ОбъектыПечати - СписокЗначений - список ссылок на объекты печати.
//  СписокПечати - СписокЗначений - список с именами макетов и представлениями печатных форм.
//  Записано - Булево - признак того, что состояние документа записано в регистр.
//
Процедура ЗаписатьСостоянияОригиналовПослеПечати(ОбъектыПечати, СписокПечати, Записано = Ложь) Экспорт

	УчетОригиналовПервичныхДокументовВызовСервера.ЗаписатьСостоянияОригиналовПослеПечати(ОбъектыПечати, СписокПечати, Записано);
	Если СписокПечати.Количество() = 0 Или Записано = Ложь Тогда
		Возврат;
	КонецЕсли;
		
	Оповестить("ИзменениеСостоянияОригиналаПервичногоДокумента");
	
	Если ОбъектыПечати.Количество() > 1 Тогда
		ОповеститьПользователяОбУстановкеСостояний(ОбъектыПечати.Количество(),,ПредопределенноеЗначение("Справочник.СостоянияОригиналовПервичныхДокументов.ФормаНапечатана"));
	ИначеЕсли ОбъектыПечати.Количество() = 1 Тогда
		ОповеститьПользователяОбУстановкеСостояний(1,ОбъектыПечати[0].Значение,ПредопределенноеЗначение("Справочник.СостоянияОригиналовПервичныхДокументов.ФормаНапечатана"));
	КонецЕсли;
	
КонецПроцедуры

// Открывает форму уточнения состояний печатных форм документа.
//
//	Параметры:
//  ДокументСсылка - ДокументСсылка - ссылка на документ,для которого необходимо получить ключ записи общего состояния.
//
Процедура ОткрытьФормуИзмененияСостоянийПечатныхФорм(ДокументСсылка) Экспорт

	КлючЗаписиРегистра = УчетОригиналовПервичныхДокументовВызовСервера.КлючЗаписиОбщегоСостояния(ДокументСсылка);
	
	ПередаваемыеПараметры = Новый Структура;
	
	Если КлючЗаписиРегистра = Неопределено Тогда
		ПередаваемыеПараметры.Вставить("ДокументСсылка",ДокументСсылка);
		ОткрытьФорму("РегистрСведений.СостоянияОригиналовПервичныхДокументов.Форма.ИзменениеСостоянийОригиналовПервичныхДокументов",ПередаваемыеПараметры);
	Иначе
		ПередаваемыеПараметры.Вставить("Ключ", КлючЗаписиРегистра);
		ОткрытьФорму("РегистрСведений.СостоянияОригиналовПервичныхДокументов.Форма.ИзменениеСостоянийОригиналовПервичныхДокументов",ПередаваемыеПараметры);
	КонецЕсли;

КонецПроцедуры

// Вызывается при открытии журнала оригиналов первичных документов в случае использования подключаемого оборудования.
// Позволяет определить собственный процесс подключения подключаемого оборудования к журналу.
//	
//	Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма списка документа.
//
Процедура ПриПодключенииСканераШтрихкода(Форма) Экспорт

	УчетОригиналовПервичныхДокументовКлиентПереопределяемый.ПриПодключенииСканераШтрихкода(Форма);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Формирует надпись для вывода информации о текущем состоянии на форму документа.
//
//	Параметры:
//  Форма - ФормаКлиентскогоПриложения:
//   * Объект - ДанныеФормыСтруктура, ДокументОбъект - основной реквизит формы.
//
Процедура СформироватьНадписьТекущегоСостоянияОригинала(Форма)
	
	ДекорацияСостояниеОригинала = Форма.Элементы.Найти("ДекорацияСостояниеОригинала");
	Если ДекорацияСостояниеОригинала = Неопределено Тогда
		Возврат;
	КонецЕсли;
		 
	Если ЗначениеЗаполнено(Форма.Объект.Ссылка) Тогда
		ТекущиеСостояниеОригинала = УчетОригиналовПервичныхДокументовВызовСервера.СведенияОСостоянииОригиналаПоСсылке(Форма.Объект.Ссылка);
		Если ТекущиеСостояниеОригинала.Количество() = 0 Тогда
			ТекущиеСостояниеОригинала=НСтр("ru = '<Состояние оригинала неизвестно>';
											|en = '<Original state is unknown>'");
			ДекорацияСостояниеОригинала.ЦветТекста = WebЦвета.Серебряный;
		Иначе
			ТекущиеСостояниеОригинала = ТекущиеСостояниеОригинала.СостояниеОригиналаПервичногоДокумента;
			ДекорацияСостояниеОригинала.ЦветТекста = Новый Цвет;
		КонецЕсли;
	Иначе
		ДекорацияСостояниеОригинала.ЦветТекста = WebЦвета.Серебряный;
	КонецЕсли;

	ДекорацияСостояниеОригинала.Заголовок = ТекущиеСостояниеОригинала;
	
КонецПроцедуры

// Обработчик оповещения, вызванного после завершения работы процедуры УстановитьСостояниеОригинала(...).
Процедура УстановитьСостояниеОригиналаЗавершение(Ответ, ДополнительныеПараметры) Экспорт

	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	Список = ДополнительныеПараметры.Список;
	ИмяСостояния = ДополнительныеПараметры.ИмяСостояния;

	Если Список.ВыделенныеСтроки.Количество() = 0 Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Не выделено ни одного документа, для которого можно установить выбранное состояние.';
										|en = 'No document, for which the selected state can be set, is selected.'"));
		Возврат;
	КонецЕсли;

	МассивСтрок = Новый Массив;
	Для Каждого СтрокаСписка Из Список.ВыделенныеСтроки Цикл
		ДанныеСтроки = Список.ДанныеСтроки(СтрокаСписка);
		МассивСтрок.Добавить(ДанныеСтроки);
	КонецЦикла;
	
	ОбъектыЗаписи = УчетОригиналовПервичныхДокументовВызовСервера.ВозможностьЗаписиОбъектов(МассивСтрок); // Массив из ДокументСсылка-
	Если Не ТипЗнч(ОбъектыЗаписи) = Тип("Массив") Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Для выполнения команды предварительно проведите все выделенные документы.';
										|en = 'To run the command, post all selected documents first.'"));
		Возврат;
	КонецЕсли;

	Изменено = Ложь;
	УчетОригиналовПервичныхДокументовВызовСервера.УстановитьНовоеСостояниеОригинала(ОбъектыЗаписи, ИмяСостояния, Изменено);

	Если ОбъектыЗаписи.Количество() = 1 И Изменено Тогда 
		ОповеститьПользователяОбУстановкеСостояний(1,ОбъектыЗаписи[0].Ссылка);
	ИначеЕсли Изменено Тогда
		ОповеститьПользователяОбУстановкеСостояний(ОбъектыЗаписи.Количество(),,ИмяСостояния);
	КонецЕсли;
	
	Если Изменено Тогда
		Оповестить("ИзменениеСостоянияОригиналаПервичногоДокумента");
	КонецЕсли;

КонецПроцедуры

// Обработчик оповещения, вызванного после завершения работы процедуры ОткрытьМенюВыбораСостояния(...).
//	
//	Параметры:
//  ВыбранноеСостояниеИзСписка - Строка - выбранное пользователем состояние оригинала.
//  ДополнительныеПараметры - Структура - сведения необходимые для установки состояния оригинала:
//                            * Ссылка - ДокументСсылка - ссылка на документ для установки состояния оригинала.
//       	                - Массив из ДокументСсылка:
//                            * Ссылка - ДокументСсылка - ссылка на документ для установки состояния оригинала.
//
Процедура ОткрытьМенюВыбораСостоянияЗавершение(ВыбранноеСостояниеИзСписка, ДополнительныеПараметры) Экспорт

	Если Не ВыбранноеСостояниеИзСписка = Неопределено Тогда
		Если ТипЗнч(ДополнительныеПараметры)= Тип("Массив")Тогда
			ОткрытьМенюВыбораСостоянияЗавершениеМассив(ВыбранноеСостояниеИзСписка, ДополнительныеПараметры);
		Иначе
			ОткрытьМенюВыбораСостоянияЗавершениеСтруктура(ВыбранноеСостояниеИзСписка, ДополнительныеПараметры);
		КонецЕсли;
	Иначе
		Возврат;
	КонецЕсли;

КонецПроцедуры

// Обработчик оповещения, вызванного после завершения работы процедуры ОткрытьМенюВыбораСостояния(...).
//	
//	Параметры:
//  ВыбранноеСостояниеИзСписка - Строка - выбранное пользователем состояние оригинала.
//  ДополнительныеПараметры - Массив из ДокументСсылка:
//                            * Ссылка - ДокументСсылка - ссылка на документ для установки состояния оригинала.
//
Процедура ОткрытьМенюВыбораСостоянияЗавершениеМассив(ВыбранноеСостояниеИзСписка, ДополнительныеПараметры)

	Изменено = Ложь;
	
	Если ВыбранноеСостояниеИзСписка.Значение = "УточнитьПоПечатнымФормам" Тогда
		ОткрытьФормуИзмененияСостоянийПечатныхФорм(ДополнительныеПараметры[0].Ссылка);
	Иначе
		УчетОригиналовПервичныхДокументовВызовСервера.УстановитьНовоеСостояниеОригинала(ДополнительныеПараметры,ВыбранноеСостояниеИзСписка.Значение, Изменено);
		Если Изменено Тогда
			ОповеститьПользователяОбУстановкеСостояний(1,ДополнительныеПараметры[0].Ссылка,ВыбранноеСостояниеИзСписка.Значение);
			Оповестить("ИзменениеСостоянияОригиналаПервичногоДокумента");
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

// Обработчик оповещения, вызванного после завершения работы процедуры ОткрытьМенюВыбораСостояния(...).
//	
//	Параметры:
//  ВыбранноеСостояниеИзСписка - Строка - выбранное пользователем состояние оригинала.
//  ДополнительныеПараметры - Структура - сведения необходимые для установки состояния оригинала:
//                            * Ссылка - ДокументСсылка - ссылка на документ для установки состояния оригинала.
//
Процедура ОткрытьМенюВыбораСостоянияЗавершениеСтруктура(ВыбранноеСостояниеИзСписка, ДополнительныеПараметры)

	Изменено = Ложь;
	
	Если ВыбранноеСостояниеИзСписка.Значение = "УточнитьПоПечатнымФормам" Тогда
		ОткрытьФормуИзмененияСостоянийПечатныхФорм(ДополнительныеПараметры.Ссылка);
	Иначе
		УчетОригиналовПервичныхДокументовВызовСервера.УстановитьНовоеСостояниеОригинала(ДополнительныеПараметры.Ссылка,ВыбранноеСостояниеИзСписка.Значение, Изменено);
		Если Изменено Тогда
			ОповеститьПользователяОбУстановкеСостояний(1,ДополнительныеПараметры.Ссылка,ВыбранноеСостояниеИзСписка.Значение);
			Оповестить("ИзменениеСостоянияОригиналаПервичногоДокумента");
			КонецЕсли;
	КонецЕсли;

КонецПроцедуры

// Обработчик оповещения, вызванного после завершения работы процедуры ОповеститьПользователяОбУстановкеСостояний(...).
Процедура ОбработатьНажатиеНаОповещение(ДополнительныеПараметры) Экспорт

	ПоказатьЗначение(,ДополнительныеПараметры);

КонецПроцедуры

#КонецОбласти
