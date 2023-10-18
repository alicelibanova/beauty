﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Взаимодействия.ОбработатьНеобходимостьОтображенияГруппПользователей(ЭтотОбъект);
	
	Взаимодействия.ДобавитьСтраницыФормыПодбораКонтактов(ЭтотОбъект);
	ЗаполнитьТаблицуПолучателей();
	УстановитьГруппуПоУмолчанию();

	ВидыКонтактнойИнформации = УправлениеКонтактнойИнформацией.ВидыКонтактнойИнформацииОбъекта(
		Справочники.Пользователи.ПустаяСсылка(), Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты);
	Если ВидыКонтактнойИнформации.Количество() > 0 Тогда
		ВидЭлектроннаяПочта = ВидыКонтактнойИнформации[0].Ссылка;
	Иначе
		ВидЭлектроннаяПочта = Неопределено;
	КонецЕсли;
	Если СписокПользователей.Параметры.Элементы.Найти("ЭлектроннаяПочта") <> Неопределено Тогда
		СписокПользователей.Параметры.УстановитьЗначениеПараметра("ЭлектроннаяПочта", ВидЭлектроннаяПочта);
	КонецЕсли;
	
	// Заполним контакты по предмету.
	Предмет = Параметры.Предмет;
	Взаимодействия.ЗаполнитьКонтактыПоПредмету(Элементы, Предмет, КонтактыПоПредмету, Истина);
	
	ВариантыПоиска = "Везде";
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	ОбновитьМенюВариантовПоиска();
	УправлениеСтраницами();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ВзаимодействияКлиент.ОтработатьОповещение(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ПриИзмененииТолькоКонтактыСАдресами(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	УправлениеСтраницами();
	
КонецПроцедуры

&НаКлиенте
Процедура КонтактНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.ПолучателиПисьма.ТекущиеДанные;
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ТолькоEmail",                       Истина);
	ПараметрыОткрытия.Вставить("ТолькоТелефон",                     Ложь);
	ПараметрыОткрытия.Вставить("ЗаменятьПустыеАдресИПредставление", Истина);
	ПараметрыОткрытия.Вставить("ДляФормыУточненияКонтактов",        Ложь);
	ПараметрыОткрытия.Вставить("ИдентификаторФормы",                УникальныйИдентификатор);

	ВзаимодействияКлиент.ВыбратьКонтакт(Предмет, ТекущиеДанные.Адрес, ТекущиеДанные.Представление,
	                                    ТекущиеДанные.Контакт,ПараметрыОткрытия)
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучателиПисьмаПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		Элемент.ТекущиеДанные.Группа = "Кому";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучателиПисьмаПриАктивизацииЯчейки(Элемент)
	
	Если Элемент.ТекущийЭлемент.Имя = "Адрес" Тогда
		Элементы.Адрес.СписокВыбора.Очистить();
		
		ТекущиеДанные = Элементы.ПолучателиПисьма.ТекущиеДанные;
		Если ТекущиеДанные = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		Если НЕ ПустаяСтрока(ТекущиеДанные.СписокАдресов) Тогда
			Элементы.Адрес.СписокВыбора.ЗагрузитьЗначения(
				СтрРазделить(ТекущиеДанные.СписокАдресов, ";"));
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КонтактыПоПредметуВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	ДобавитьПолучателяИзСпискаПоПредмету();

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_СписокСправочникаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Не ЗначениеЗаполнено(ВыбраннаяСтрока) Тогда
		Возврат;
	КонецЕсли;
	
	Результат = ВзаимодействияВызовСервера.НаименованиеИАдресаЭлектроннойПочтыКонтакта(ВыбраннаяСтрока);
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Адрес = Результат.Адреса[0];
	СписокАдресов = СтрСоединить(Результат.Адреса.ВыгрузитьЗначения(), ";");
	
	ДобавитьПолучателя(Адрес, Результат.Наименование, ВыбраннаяСтрока, СписокАдресов);
	
КонецПроцедуры

// Универсальный обработчик активизации строки динамического списка, у которого есть подчиненные списки.
&НаКлиенте
Процедура Подключаемый_СписокВладелецПриАктивизацииСтроки(Элемент)
	
	ВзаимодействияКлиент.КонтактВладелецПриАктивизацииСтроки(Элемент, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура НайденныеКонтактыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.НайденныеКонтакты.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Результат = ВзаимодействияВызовСервера.НаименованиеИАдресаЭлектроннойПочтыКонтакта(ТекущиеДанные.Ссылка);
	Если Результат <> Неопределено И Результат.Адреса.Количество() > 0 Тогда
		СписокАдресов = СтрСоединить(Результат.Адреса.ВыгрузитьЗначения(), ";");
	Иначе
		СписокАдресов = "";
	КонецЕсли;
	
	ДобавитьПолучателя(ТекущиеДанные.Представление, ТекущиеДанные.НаименованиеКонтакта, ТекущиеДанные.Ссылка, СписокАдресов);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппыПользователейПриАктивизацииСтроки(Элемент)
	
	СписокПользователей.Параметры.УстановитьЗначениеПараметра("ГруппаПользователей", Элементы.ГруппыПользователей.ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьТолькоКонтактыСАдресамиПриИзменении(Элемент)
	
	ПриИзмененииТолькоКонтактыСАдресами(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// Передает владельцу в качестве результата работы формы массив структур содержащих 
// адреса выбранных получателей и закрывает форму. 
//
&НаКлиенте
Процедура КомандаОКВыполнить()
	
	Результат = Новый Массив;
	
	Для Каждого СтрокаТаблицы Из ПолучателиПисьма Цикл
		
		Если ПустаяСтрока(СтрокаТаблицы.Адрес) Тогда
			Продолжить;
		КонецЕсли;
		Группа = ?(ПустаяСтрока(СтрокаТаблицы.Группа), "Кому", СтрокаТаблицы.Группа);
		
		Контакт = Новый Структура;
		Контакт.Вставить("Адрес", СтрокаТаблицы.Адрес);
		Контакт.Вставить("Представление", СтрокаТаблицы.Представление);
		Контакт.Вставить("Контакт", СтрокаТаблицы.Контакт);
		Контакт.Вставить("Группа", Группа);
		Результат.Добавить(Контакт);
		
	КонецЦикла;
	
	ОповеститьОВыборе(Результат);
	
КонецПроцедуры

// Переносит текущий контакт из списка "Контакты по предмету" в список "Получатели письма". 
//
&НаКлиенте
Процедура ДобавитьИзСпискаПредметовВыполнить()

	ДобавитьПолучателяИзСпискаПоПредмету();

КонецПроцедуры

// Изменяет текущую группу получателей письма на группу "Кому". 
//
&НаКлиенте
Процедура ИзменитьГруппуКомуВыполнить()

	ИзменитьГруппу("Кому");

КонецПроцедуры

// Изменяет текущую группу получателей письма на группу "Копии". 
//
&НаКлиенте
Процедура ИзменитьГруппуКопииВыполнить()

	ИзменитьГруппу("Копии");

КонецПроцедуры 

// Изменяет текущую группу получателей письма на группу "Скрытые". 
//
&НаКлиенте
Процедура ИзменитьГруппуСкрытыеВыполнить()

	ИзменитьГруппу("Скрытые");

КонецПроцедуры

// Инициирует процесс поиска контактов.
//
&НаКлиенте
Процедура НайтиКонтактыВыполнить()
	
	Если ПустаяСтрока(СтрокаПоиска) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не задано, что нужно найти.';
														|en = 'Please enter a search string.'"),, "СтрокаПоиска");
		Возврат;
	КонецЕсли;
	
	Результат = "";
	НайденныеКонтакты.Очистить();
	
	Если ВариантыПоиска = "Везде" Тогда
		Результат = НайтиКонтакты();
	ИначеЕсли ВариантыПоиска = "ПоEmail" Тогда
		НайтиПоEmail(Ложь);
	ИначеЕсли ВариантыПоиска = "ПоДомену" Тогда
		НайтиПоEmail(Истина);
	ИначеЕсли ВариантыПоиска = "ПоСтроке" Тогда
		Результат = КонтактыНайденныеПоСтроке();
	ИначеЕсли ВариантыПоиска = "НачинаетсяС" Тогда
		НайтиПоНачалуНаименования();
	КонецЕсли;
	
	Если Не ПустаяСтрока(Результат) Тогда
		ПоказатьПредупреждение(, Результат);
	КонецЕсли;
	
КонецПроцедуры

// Выполняет позиционирование в соответствующем динамическом списке на текущем контакте из 
// списка "Найденные контакты".
//
&НаКлиенте
Процедура НайтиВСпискеИзСпискаНайденныхВыполнить()
	
	ТекущиеДанные = Элементы.НайденныеКонтакты.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено И ЗначениеЗаполнено(ТекущиеДанные.Ссылка) Тогда
		УстановитьТекущимКонтакт(ТекущиеДанные.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

// Выполняет позиционирование в соответствующем динамическом списке на текущем контакте
// из списка "Получатели письма".
//
&НаКлиенте
Процедура НайтиВСпискеИзСпискаПолучателейВыполнить()
	
	ТекущиеДанные = Элементы.ПолучателиПисьма.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено И ЗначениеЗаполнено(ТекущиеДанные.Контакт) Тогда
		УстановитьТекущимКонтакт(ТекущиеДанные.Контакт);
	КонецЕсли;
	
КонецПроцедуры

// Выполняет позиционирование в соответствующем динамическом списке на текущем контакте
// из списка "Контакты по предмету".
//
&НаКлиенте
Процедура НайтиВСпискеИзСпискаПредметовВыполнить()
	
	ТекущиеДанные = Элементы.КонтактыПоПредмету.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		УстановитьТекущимКонтакт(ТекущиеДанные.Ссылка);
	КонецЕсли;
	
КонецПроцедуры 

// Инициирует поиск контактов по адресу электронной почты текущей строки списка "Получатели письма". 
//
&НаКлиенте
Процедура НайтиПоАдресуВыполнить()
	
	Элементы.СтраницыСписки.ТекущаяСтраница = Элементы.СтраницаПоискКонтактов;
	НайденныеКонтакты.Очистить();

	ТекущиеДанные = Элементы.ПолучателиПисьма.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;

	СтрокаПоиска = ТекущиеДанные.Адрес;
	Если Не ПустаяСтрока(СтрокаПоиска) Тогда
		НайтиПоEmail(Ложь);
	КонецЕсли;

КонецПроцедуры

// Инициирует поиск контактов по представлению текущей строки списка "Получатели письма". 
//
&НаКлиенте
Процедура НайтиПоПредставлениюВыполнить()
	
	Элементы.СтраницыСписки.ТекущаяСтраница = Элементы.СтраницаПоискКонтактов;
	НайденныеКонтакты.Очистить();
	
	ТекущиеДанные = Элементы.ПолучателиПисьма.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаПоиска = ТекущиеДанные.Представление;
	Если Не ПустаяСтрока(СтрокаПоиска) Тогда
		Результат = КонтактыНайденныеПоСтроке();
		Если Не ПустаяСтрока(Результат) Тогда
			ПоказатьПредупреждение(,Результат);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры 

// Осуществляет поиск всех адресов электронной почты контакта из списка "Получатели письма" и
 // предлагает пользователю сделать выбор, если у контакта более одного адреса электронной почты.
//
&НаКлиенте
Процедура УстановитьАдресКонтактаВыполнить()
	
	ТекущиеДанные = Элементы.ПолучателиПисьма.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Выберите адрес получателя в списке справа.';
										|en = 'Select the recipient''s address in the list on the right.'"));
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ТекущиеДанные.Контакт) Тогда
		КонтактНачалоВыбора(Элементы.ПолучателиПисьма, Неопределено, Истина);
		Возврат;
	КонецЕсли;
	
	Результат = ВзаимодействияВызовСервера.ПолучитьАдресаЭлектроннойПочтыКонтакта(ТекущиеДанные.Контакт);
	Если Результат.Количество() = 0 Тогда
		ПоказатьПредупреждение(, 
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'У контакта ""%1"" нет адресов электронной почты.';
					|en = 'The following contact does not have an email: ""%1"".'"),
				ТекущиеДанные.Контакт));
		Возврат;
	КонецЕсли;

	Если Результат.Количество() = 1 Тогда
		Адрес = Результат[0].АдресЭП;
		Представление = Результат[0].Представление;
		УстановитьАдресИПредставлениеВыбранногоКонтакта(ТекущиеДанные, Представление, Адрес);
	Иначе
		СписокВыбора = Новый СписокЗначений;
		Номер = 0;
		Для Каждого Элемент Из Результат Цикл
			СписокВыбора.Добавить(Номер, Элемент.ВидНаименование + ": " + Элемент.АдресЭП);
			Номер = Номер + 1;
		КонецЦикла;
		
		ПараметрыОбработкиВыбора = Новый Структура;
		ПараметрыОбработкиВыбора.Вставить("Результат", Результат);
		ПараметрыОбработкиВыбора.Вставить("ТекущиеДанные", ТекущиеДанные);

		ОбработчикОповещенияОЗакрытии = Новый ОписаниеОповещения("СписокВыбораАдресаЭППослеЗавершения", ЭтотОбъект, ПараметрыОбработкиВыбора);

		СписокВыбора.ПоказатьВыборЭлемента(ОбработчикОповещенияОЗакрытии);
	КонецЕсли;

КонецПроцедуры

// Выполняет позиционирование в соответствующем динамическом списке на текущем контакте
// из списка "Контакты по предмету".
//
&НаКлиенте
Процедура УстановитьКонтактИзСпискаПредметовВыполнить()
	
	ТекущиеДанные = Элементы.КонтактыПоПредмету.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		УстановитьКонтактВСпискеПолучателей(ТекущиеДанные.Ссылка);
	КонецЕсли;
	
КонецПроцедуры 

&НаКлиенте
Процедура УдалитьВсехПолучателей(Команда)
	
	ПолучателиПисьма.Очистить();
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьПолучателя(Команда)
	
	ВыделенныеСтроки = Элементы.ПолучателиПисьма.ВыделенныеСтроки;
	Для каждого ВыделеннаяСтрока Из ВыделенныеСтроки Цикл
		ПолучателиПисьма.Удалить(ПолучателиПисьма.НайтиПоИдентификатору(ВыделеннаяСтрока));
	КонецЦикла;
	
КонецПроцедуры

// Возвращает данные строки таблицы Найденные контакты.
// 
// Параметры:
//  ВыделеннаяСтрока  - ДанныеФормыЭлементКоллекции - строка, данные которой получаются.
//
// Возвращаемое значение:
//  Структура:
//   * НаименованиеКонтакта - Строка
//   * ИмяСправочника       - Строка
//   * Представление        - Строка
//   * Ссылка               - ОпределяемыйТип.КонтактВзаимодействия
//
&НаКлиенте
Функция ДанныеСтрокиНайденныеКонтакты(ВыделеннаяСтрока)
	
	Возврат Элементы.НайденныеКонтакты.ДанныеСтроки(ВыделеннаяСтрока);
	
КонецФункции

&НаКлиенте
Процедура ВключитьВСписокПолучателей(Команда)
	
	Если Элементы.СтраницыСписки.ТекущаяСтраница = Элементы.СтраницаПоискКонтактов Тогда
		Для каждого ВыделеннаяСтрока Из Элементы.НайденныеКонтакты.ВыделенныеСтроки Цикл
			ДанныеСтроки = ДанныеСтрокиНайденныеКонтакты(ВыделеннаяСтрока);
			ДобавитьПолучателя(ДанныеСтроки.Представление, ДанныеСтроки.НаименованиеКонтакта, ДанныеСтроки.Ссылка);
		КонецЦикла;
		Возврат;
	КонецЕсли;
	
	НомерЭлементаФормы = Неопределено;
	
	Если Элементы.СтраницыСписки.ТекущаяСтраница.ПодчиненныеЭлементы.Количество() = 1 Тогда
		
		НомерЭлементаФормы = 0;
		
	ИначеЕсли Элементы.СтраницыСписки.ТекущаяСтраница.ПодчиненныеЭлементы.Количество() = 2 Тогда
		
		Если ТекущийЭлемент.Имя = "ПереместитьИзВерхнегоСпискаВВыбранное" Тогда
			НомерЭлементаФормы = 0;
		Иначе
			НомерЭлементаФормы = 1;
		КонецЕсли;
		
	КонецЕсли;
	
	Если НомерЭлементаФормы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПеренестиВыделенныеСтроки(
		Элементы.СтраницыСписки.ТекущаяСтраница.ПодчиненныеЭлементы[НомерЭлементаФормы].ВыделенныеСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантПоискаВезде(Команда)
	ВариантыПоиска = "Везде";
	ОбновитьМенюВариантовПоиска();
КонецПроцедуры

&НаКлиенте
Процедура ВариантПоискаВАдресах(Команда)
	ВариантыПоиска = "ПоEmail";
	ОбновитьМенюВариантовПоиска();
КонецПроцедуры

&НаКлиенте
Процедура ВариантПоискаВНаименованияхКонтактов(Команда)
	ВариантыПоиска = "ПоСтроке";
	ОбновитьМенюВариантовПоиска();
КонецПроцедуры

&НаКлиенте
Процедура ВариантПоискаПоДоменномуИмени(Команда)
	ВариантыПоиска = "ПоДомену";
	ОбновитьМенюВариантовПоиска();
КонецПроцедуры

&НаКлиенте
Процедура Просмотр(Команда)
	Если Элементы.СтраницыСписки.ТекущаяСтраница = Элементы.СтраницаПользователей Тогда
		ТекущиеДанные = Элементы.СписокПользователей.ТекущиеДанные;
	ИначеЕсли ТипЗнч(ТекущийЭлемент) = Тип("ТаблицаФормы") Тогда
		ТекущиеДанные = ТекущийЭлемент.ТекущиеДанные;
	Иначе
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПоказатьЗначение(, ТекущиеДанные.Ссылка);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции осуществления поиска.

&НаСервере
Функция НайтиКонтакты()
	
	Возврат Взаимодействия.НайтиКонтакты(СтрокаПоиска, Истина, НайденныеКонтакты);
	
КонецФункции

&НаСервере
Процедура НайтиПоEmail(ПоДомену)
	
	Взаимодействия.НайтиПоEmail(СтрокаПоиска, ПоДомену, НайденныеКонтакты);
	
КонецПроцедуры

&НаСервере
Функция КонтактыНайденныеПоСтроке()
	
	Возврат Взаимодействия.ПолнотекстовыйПоискКонтактовПоСтроке(СтрокаПоиска, НайденныеКонтакты, Истина);
	
КонецФункции

&НаСервере
Процедура НайтиПоНачалуНаименования()
	
	Взаимодействия.НайтиКонтактыСАдресамиПоНаименованию(СтрокаПоиска, НайденныеКонтакты);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Прочее

&НаСервере
Процедура ЗаполнитьТаблицуПолучателей()
	
	табПолучатели = РеквизитФормыВЗначение("ПолучателиПисьма");
	
	Для Каждого ГруппаВыбранных Из Параметры.СписокВыбранных Цикл
		Если ГруппаВыбранных.Значение <> Неопределено Тогда
			Для Каждого Элемент Из ГруппаВыбранных.Значение Цикл
				НоваяСтрока = табПолучатели.Добавить();
				НоваяСтрока.Группа = ГруппаВыбранных.Представление;
				ЗаполнитьЗначенияСвойств(НоваяСтрока, Элемент);
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
	табПолучатели.Сортировать("Группа");
	
	Если табПолучатели.Количество() > 0 Тогда
		ТаблицаАдресов =
			Взаимодействия.АдресаЭлектроннойПочтыКонтактов(табПолучатели.ВыгрузитьКолонку("Контакт"));
			
			Запрос = Новый Запрос;
			Запрос.Текст = "
			|ВЫБРАТЬ
			|	ПолучателиПисьма.Адрес,
			|	ПолучателиПисьма.Представление,
			|	ПолучателиПисьма.Контакт,
			|	ПолучателиПисьма.Группа
			|ПОМЕСТИТЬ ПолучателиПисьма
			|ИЗ
			|	&ПолучателиПисьма КАК ПолучателиПисьма
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	КонтактыАдреса.Контакт,
			|	КонтактыАдреса.СписокАдресов
			|ПОМЕСТИТЬ КонтактыСписокАдресов
			|ИЗ
			|	&КонтактыАдреса КАК КонтактыАдреса
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ПолучателиПисьма.Адрес,
			|	ПолучателиПисьма.Представление,
			|	ПолучателиПисьма.Контакт,
			|	ПолучателиПисьма.Группа,
			|	ЕСТЬNULL(КонтактыСписокАдресов.СписокАдресов, """") КАК СписокАдресов
			|ИЗ
			|	ПолучателиПисьма КАК ПолучателиПисьма
			|		ЛЕВОЕ СОЕДИНЕНИЕ КонтактыСписокАдресов КАК КонтактыСписокАдресов
			|		ПО КонтактыСписокАдресов.Контакт = ПолучателиПисьма.Контакт";
			
			Запрос.УстановитьПараметр("ПолучателиПисьма", табПолучатели);
			Запрос.УстановитьПараметр("КонтактыАдреса", ТаблицаАдресов);
			
			табПолучатели = Запрос.Выполнить().Выгрузить();
		
	КонецЕсли;
	
	ЗначениеВРеквизитФормы(табПолучатели, "ПолучателиПисьма");
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьПолучателя(Адрес, Наименование, Контакт, СписокАдресов = "")
	
	УдалитьПустогоПолучателя(ПолучателиПисьма);
	
	НоваяСтрока = ПолучателиПисьма.Добавить();
	НоваяСтрока.Адрес         = Адрес;
	НоваяСтрока.Представление = Наименование;
	НоваяСтрока.Контакт       = Контакт;
	НоваяСтрока.СписокАдресов = СписокАдресов;
	НоваяСтрока.Группа        = ГруппаПоУмолчанию;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УдалитьПустогоПолучателя(ПолучателиПисьма)
	
	Если ПолучателиПисьма.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;	
		
	ПолучательПисьма = ПолучателиПисьма[0];
	Если ПустаяСтрока(ПолучательПисьма.Адрес) И ПустаяСтрока(ПолучательПисьма.Представление) И Не ЗначениеЗаполнено(ПолучательПисьма.Контакт) Тогда
		ПолучателиПисьма.Удалить(0);
	КонецЕсли;	

КонецПроцедуры

&НаКлиенте
Процедура ДобавитьПолучателяИзСпискаПоПредмету()
	
	ТекущиеДанные = Элементы.КонтактыПоПредмету.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Результат = ВзаимодействияВызовСервера.НаименованиеИАдресаЭлектроннойПочтыКонтакта(ТекущиеДанные.Ссылка);
	Если Результат <> Неопределено И Результат.Адреса.Количество() > 0 Тогда
		СписокАдресов = СтрСоединить(Результат.Адреса.ВыгрузитьЗначения(), ";");
	Иначе
		СписокАдресов = "";
	КонецЕсли;
	
	ДобавитьПолучателя(ТекущиеДанные.Адрес, ТекущиеДанные.Наименование, ТекущиеДанные.Ссылка, СписокАдресов);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьКонтактВСпискеПолучателей(Контакт)
	
	Если ЗначениеЗаполнено(Контакт) И Элементы.ПолучателиПисьма.ТекущиеДанные <> Неопределено Тогда
		Элементы.ПолучателиПисьма.ТекущиеДанные.Контакт = Контакт;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьТекущимКонтакт(Контакт)
	
	Взаимодействия.УстановитьТекущимКонтакт(Контакт, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьГруппу(ИмяГруппы)
	
	Для Каждого ВыделеннаяСтрока Из Элементы.ПолучателиПисьма.ВыделенныеСтроки Цикл
		Элемент = ПолучателиПисьма.НайтиПоИдентификатору(ВыделеннаяСтрока);
		Элемент.Группа = ИмяГруппы;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПеренестиВыделенныеСтроки(Знач ВыделенныеСтроки)

	Результат = Взаимодействия.АдресаЭлектроннойПочтыКонтактов(ВыделенныеСтроки, ГруппаПоУмолчанию);
	Если Результат <> Неопределено Тогда
		УдалитьПустогоПолучателя(ПолучателиПисьма);
		ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(Результат, ПолучателиПисьма);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьГруппуПоУмолчанию()
	
	Если Параметры.Свойство("ГруппаПоУмолчанию") Тогда
		ГруппаПоУмолчанию = Параметры.ГруппаПоУмолчанию;
	КонецЕсли;
	Если ПустаяСтрока(ГруппаПоУмолчанию) Тогда
		ГруппаПоУмолчанию = НСтр("ru = 'Кому';
								|en = 'To'");
	КонецЕсли;
	
КонецПроцедуры 

&НаКлиенте
Процедура УправлениеСтраницами()

	Если Элементы.СтраницыСписки.ТекущаяСтраница = Элементы.СтраницаВсеКонтактыПоПредмету 
		ИЛИ Элементы.СтраницыСписки.ТекущаяСтраница = Элементы.СтраницаПоискКонтактов 
		ИЛИ Элементы.СтраницыСписки.ТекущаяСтраница.ПодчиненныеЭлементы.Количество() = 1 
		ИЛИ (Элементы.СтраницыСписки.ТекущаяСтраница = Элементы.СтраницаПользователей 
		И (НЕ ИспользоватьГруппыПользователей))Тогда
		
		Элементы.СтраницыПереместить.ТекущаяСтраница = Элементы.СтраницаПереместитьОднаТаблица;
		
	Иначе
		
		Элементы.СтраницыПереместить.ТекущаяСтраница = Элементы.СтраницаПереместитьДвеТаблицы;
		
	КонецЕсли;

КонецПроцедуры 

&НаКлиенте
Процедура СписокВыбораАдресаЭППослеЗавершения(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт

	Если ВыбранныйЭлемент = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Индекс = ВыбранныйЭлемент.Значение;
	Адрес = ДополнительныеПараметры.Результат[Индекс].АдресЭП;
	Представление = ДополнительныеПараметры.Результат[Индекс].Представление;
	УстановитьАдресИПредставлениеВыбранногоКонтакта(ДополнительныеПараметры.ТекущиеДанные, Представление, Адрес);

КонецПроцедуры

&НаКлиенте
Процедура УстановитьАдресИПредставлениеВыбранногоКонтакта(ТекущиеДанные, Представление, Адрес)

	Позиция = СтрНайти(Представление, "<");
	Представление = ?(Позиция= 0, "", СокрЛП(Лев(Представление, Позиция-1)));

	ТекущиеДанные.Адрес = Адрес;
	Если Не ПустаяСтрока(Представление) Тогда
		ТекущиеДанные.Представление = Представление;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	ОбщегоНазначения.УстановитьУсловноеОформлениеСпискаВыбора(ЭтотОбъект, "Группа", "ПолучателиПисьма.Группа");
	
КонецПроцедуры 

&НаКлиенте
Процедура ОбновитьМенюВариантовПоиска()
	
	Элементы.ВариантПоискаВезде.Пометка = (ВариантыПоиска = "Везде");
	Элементы.ВариантПоискаВАдресах.Пометка = (ВариантыПоиска = "ПоEmail");
	Элементы.ВариантПоискаВНаименованияхКонтактов.Пометка = (ВариантыПоиска = "ПоСтроке");
	Элементы.ВариантПоискаПоДоменномуИмени.Пометка = (ВариантыПоиска = "ПоДомену");

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ПриИзмененииТолькоКонтактыСАдресами(Форма)

		Для Каждого ИмяСписка Из Форма.ИменаДобавленныхТаблиц Цикл
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Форма.ЭтотОбъект[ИмяСписка.Значение], "Адрес", , ВидСравненияКомпоновкиДанных.Заполнено,, Форма.ПоказыватьТолькоКонтактыСАдресами);
		
	КонецЦикла;
	
	Если Форма.ПоказыватьТолькоКонтактыСАдресами Тогда
		
		Форма.Элементы.КонтактыПоПредмету.ОтборСтрок = Новый ФиксированнаяСтруктура("АдресЗаполнен", Истина);
		Форма.Элементы.НайденныеКонтакты.ОтборСтрок  = Новый ФиксированнаяСтруктура("ПредставлениеЗаполнено", Истина);
		
		
	Иначе
		
		Форма.Элементы.НайденныеКонтакты.ОтборСтрок  = Неопределено;
		Форма.Элементы.КонтактыПоПредмету.ОтборСтрок = Неопределено;
		
	КонецЕсли

КонецПроцедуры

#КонецОбласти
