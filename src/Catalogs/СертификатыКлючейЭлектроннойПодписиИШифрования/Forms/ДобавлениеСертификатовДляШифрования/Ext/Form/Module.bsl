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
	
	ПомещенныеФайлы = Параметры.ПомещенныеФайлы;
	
	ДляПоискаФизическихЛиц = Новый Массив;
	
	Если ЗначениеЗаполнено(ПомещенныеФайлы) Тогда
		
		Для Каждого ФайлСертификата Из ПомещенныеФайлы Цикл
			
			ДанныеСертификата = ПолучитьИзВременногоХранилища(ФайлСертификата.Хранение);
		
			СертификатКриптографии = ЭлектроннаяПодписьСлужебный.СертификатИзДвоичныхДанных(ДанныеСертификата);
			Если СертификатКриптографии = Неопределено Тогда
				НоваяСтрока = ФайлыНеЯвляютсяСертификатами.Добавить();
				Если ЗначениеЗаполнено(ФайлСертификата.ПолноеИмя) Тогда
					НоваяСтрока.ПутьКФайлу = ФайлСертификата.ПолноеИмя;
				Иначе
					НоваяСтрока.ПутьКФайлу = ФайлСертификата.ИмяФайла;
				КонецЕсли;
			Иначе
				СвойстваСертификата = ЭлектроннаяПодпись.СвойстваСертификата(СертификатКриптографии);
				
				Если Сертификаты.НайтиСтроки(Новый Структура("Отпечаток, ДействителенДо", 
					СвойстваСертификата.Отпечаток, СвойстваСертификата.ДействителенДо)).Количество() > 0 Тогда
					Продолжить;
				КонецЕсли;
				
				КомуВыдан = ЭлектроннаяПодписьСлужебныйКлиентСервер.ПреобразоватьКомуВыданКВидуФИО(СвойстваСертификата.КомуВыдан); // Строка
				
				НоваяСтрока = Сертификаты.Добавить();
				НоваяСтрока.Представление = СвойстваСертификата.Представление;
				НоваяСтрока.КомуВыдан = КомуВыдан;
				НоваяСтрока.АдресСертификата = ПоместитьВоВременноеХранилище(СертификатКриптографии.Выгрузить(), УникальныйИдентификатор);
				НоваяСтрока.Отпечаток = СвойстваСертификата.Отпечаток;
				НоваяСтрока.ДействителенДо = СвойстваСертификата.ДействителенДо;
				
				ДляПоискаФизическихЛиц.Добавить(КомуВыдан);
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
	Если Метаданные.ОпределяемыеТипы.ФизическоеЛицо.Тип.СодержитТип(Тип("Строка")) Тогда
		Элементы.СертификатыФизическоеЛицо.Видимость = Ложь;
	Иначе
		Элементы.СертификатыФизическоеЛицо.Подсказка =
			Метаданные.Справочники.СертификатыКлючейЭлектроннойПодписиИШифрования.Реквизиты.ФизическоеЛицо.Подсказка;
	КонецЕсли;
	
	ЗаполнитьСертификатыВТаблице();
	
	Если Элементы.СертификатыФизическоеЛицо.Видимость И ДляПоискаФизическихЛиц.Количество() > 0 Тогда
		
		ФизическиеЛица = ЭлектроннаяПодписьСлужебный.ПолучитьФизическиеЛицаПоПолюСертификатаКомуВыдан(ДляПоискаФизическихЛиц);
		Для Каждого ТекущаяСтрока Из Сертификаты Цикл
			
			Если ЗначениеЗаполнено(ТекущаяСтрока.ФизическоеЛицо) Тогда
				Продолжить;
			КонецЕсли;
			
			МассивЗначений = ФизическиеЛица.Получить(ТекущаяСтрока.КомуВыдан);
			Если ТипЗнч(МассивЗначений) = Тип("Массив") И МассивЗначений.Количество() = 1 Тогда
				ТекущаяСтрока.ФизическоеЛицо = МассивЗначений[0];
				ТекущаяСтрока.Обновить = Истина;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Элементы.ФайлыНеЯвляютсяСертификатами.Видимость = ФайлыНеЯвляютсяСертификатами.Количество() > 0;
	
	Если Метаданные.ОпределяемыеТипы.Организация.Тип.СодержитТип(Тип("Строка")) Тогда
		Элементы.Организация.Видимость = Ложь;
	Иначе
		Если Параметры.Свойство("Организация") Тогда
			Организация = Параметры.Организация;
		КонецЕсли;
		
		Элементы.Организация.Подсказка =
			Метаданные.Справочники.СертификатыКлючейЭлектроннойПодписиИШифрования.Реквизиты.Организация.Подсказка;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_СертификатыКлючейЭлектроннойПодписиИШифрования" Тогда
		
		Если Не Элементы.СертификатыФизическоеЛицо.Видимость Тогда
			Возврат;
		КонецЕсли;
		
		Найдено = Сертификаты.НайтиСтроки(Новый Структура("Сертификат", Источник));
		
		Если Найдено.Количество() = 0 Тогда
			Возврат;
		КонецЕсли;
		
		ФизическоеЛицоСертификата = ФизическоеЛицоСертификата(Источник);
		Для Каждого ТекущаяСтрока Из Найдено Цикл
			ТекущаяСтрока.ФизическоеЛицо = ФизическоеЛицоСертификата;
			ТекущаяСтрока.Обновить = Ложь;
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСертификаты

&НаКлиенте
Процедура СертификатыПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанные = Элементы.Сертификаты.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.СертификатыСертификат.Видимость = ЗначениеЗаполнено(ТекущиеДанные.Сертификат);
	
	Если РасширениеПодключено = Ложь Тогда
		ЗаполнитьОписаниеДанныхСертификатаНаСервере(ТекущиеДанные.АдресСертификата);
	ИначеЕсли РасширениеПодключено = Истина Тогда
		ЗаполнитьОписаниеДанныхСертификата(Истина, ТекущиеДанные.АдресСертификата);
	Иначе
		ЭлектроннаяПодписьКлиент.УстановитьРасширение(Ложь, Новый ОписаниеОповещения(
			"ЗаполнитьОписаниеДанныхСертификата", ЭтотОбъект, ТекущиеДанные.АдресСертификата),
			НСтр("ru = 'Для продолжения установите расширение для работы с криптографией.';
				|en = 'To continue, install the cryptography extension.'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, ЭтоГруппа, Параметр)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатыФизическоеЛицоАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	НачалоВыбораФизическогоЛица(СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатыФизическоеЛицоНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	НачалоВыбораФизическогоЛица(СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатыПредставлениеПриИзменении(Элемент)
	
	Элементы.Сертификаты.ТекущиеДанные.Обновить = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоказатьДанныеСертификата(Команда)
	
	Если Элементы.Сертификаты.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СертификатАдрес = Элементы.Сертификаты.ТекущиеДанные.АдресСертификата;
	ЭлектроннаяПодписьКлиент.ОткрытьСертификат(СертификатАдрес, Истина);
	
КонецПроцедуры

&НаКлиенте
Асинх Процедура ДобавитьСертификатыВСправочник(Команда)
	
	Успех = ДобавитьСертификатыВСправочникНаСервере();
	Оповестить("Запись_СертификатыКлючейЭлектроннойПодписиИШифрования");
	
	Если Успех Тогда
		Ответ = Ждать ВопросАсинх(НСтр("ru = 'Сертификаты добавлены успешно. Закрыть форму?';
										|en = 'Certificates are added. Do you want to close the form?'"), РежимДиалогаВопрос.ДаНет);
		Если Ответ = КодВозвратаДиалога.Да Тогда
			Закрыть();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПриЗакрытииФормыВыбораФизическогоЛица(Значение, Параметры) Экспорт

	Если Значение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.Сертификаты.ТекущиеДанные.ФизическоеЛицо = Значение;
	Элементы.Сертификаты.ТекущиеДанные.Обновить = Истина;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСертификатыВТаблице()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Отпечатки", Сертификаты.Выгрузить(, "Отпечаток"));
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Отпечатки.Отпечаток
	|ПОМЕСТИТЬ Отпечатки
	|ИЗ
	|	&Отпечатки КАК Отпечатки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Сертификаты.Отпечаток,
	|	Сертификаты.ФизическоеЛицо,
	|	Сертификаты.Ссылка
	|ИЗ
	|	Справочник.СертификатыКлючейЭлектроннойПодписиИШифрования КАК Сертификаты
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Отпечатки КАК Отпечатки
	|		ПО Сертификаты.Отпечаток = Отпечатки.Отпечаток";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		СтрокаСертификата = Сертификаты.НайтиСтроки(Новый Структура("Отпечаток", Выборка.Отпечаток));
		Для Каждого ТекущаяСтрока Из СтрокаСертификата Цикл
			
			Если Элементы.СертификатыФизическоеЛицо.Видимость Тогда
				ТекущаяСтрока.ФизическоеЛицо = Выборка.ФизическоеЛицо;
			КонецЕсли;
			ТекущаяСтрока.Сертификат     = Выборка.Ссылка;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ФизическоеЛицоСертификата(Сертификат)
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Сертификат, "ФизическоеЛицо");
	
КонецФункции

&НаКлиенте
Процедура НачалоВыбораФизическогоЛица(СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.Сертификаты.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекущиеДанные.Сертификат) И ЗначениеЗаполнено(ТекущиеДанные.ФизическоеЛицо)
		И Не ТекущиеДанные.Обновить Тогда
			СтандартнаяОбработка = Ложь;
			ПоказатьЗначение(, ТекущиеДанные.Сертификат);
		Возврат;
	КонецЕсли;
	
	Результат = ЭлектроннаяПодписьСлужебныйВызовСервера.ПолучитьФизическиеЛицаПоПолюСертификатаКомуВыдан(
		ТекущиеДанные.КомуВыдан);
		
	Если Не Результат.Свойство("ФизическиеЛица") Тогда
		Возврат;
	КонецЕсли;
	
	ФизическиеЛица = Результат.ФизическиеЛица.Получить(ТекущиеДанные.КомуВыдан);
	
	СтандартнаяОбработка = Ложь;
	
	Если ФизическиеЛица = Неопределено Тогда
		ОбработкаВыбора = Новый ОписаниеОповещения("ПриЗакрытииФормыВыбораФизическогоЛица", ЭтотОбъект);
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("РежимВыбора", Истина);
		ОткрытьФорму(Результат.ПутьФормыВыбораФизическогоЛица, ПараметрыФормы, ЭтотОбъект, , , , ОбработкаВыбора,
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		Возврат;
	КонецЕсли;
	
	Если ФизическиеЛица.Количество() = 1 Тогда
		Если ТекущиеДанные.ФизическоеЛицо <> ФизическиеЛица[0] Тогда
			ТекущиеДанные.ФизическоеЛицо = ФизическиеЛица[0];
		Иначе
			ОбработкаВыбора = Новый ОписаниеОповещения("ПриЗакрытииФормыВыбораФизическогоЛица", ЭтотОбъект);
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("РежимВыбора", Истина);
			ОткрытьФорму(Результат.ПутьФормыВыбораФизическогоЛица, ПараметрыФормы, ЭтотОбъект, , , , ОбработкаВыбора,
				РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	ФиксированныеНастройки = Новый НастройкиКомпоновкиДанных;

	Отбор = ФиксированныеНастройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	Отбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Ссылка");
	Отбор.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	Отбор.ПравоеЗначение = ФизическиеЛица;
	Отбор.Использование = Истина;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ФиксированныеНастройки", ФиксированныеНастройки);
	ПараметрыФормы.Вставить("ОтборПоСсылке", Истина);
	ПараметрыФормы.Вставить("РежимВыбора", Истина);

	ОбработкаВыбора = Новый ОписаниеОповещения("ПриЗакрытииФормыВыбораФизическогоЛица", ЭтотОбъект);
	ОткрытьФорму(Результат.ПутьФормыВыбораФизическогоЛица, ПараметрыФормы, ЭтотОбъект, , , , ОбработкаВыбора,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
КонецПроцедуры

&НаСервере
Функция ДобавитьСертификатыВСправочникНаСервере()
	
	Успех = Истина;
	
	Для Каждого ТекущаяСтрока Из Сертификаты Цикл
		
		ПараметрыСертификата = Новый Структура;
		
		Если ЗначениеЗаполнено(ТекущаяСтрока.Сертификат) Тогда
			Если ТекущаяСтрока.Обновить Тогда
				ПараметрыСертификата.Вставить("СсылкаНаСертификат", ТекущаяСтрока.Сертификат);
			Иначе
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		
		ПараметрыСертификата.Вставить("Наименование", ТекущаяСтрока.Представление);
		
		Если Элементы.СертификатыФизическоеЛицо.Видимость И ЗначениеЗаполнено(ТекущаяСтрока.ФизическоеЛицо) Тогда
			ПараметрыСертификата.Вставить("ФизическоеЛицо", ТекущаяСтрока.ФизическоеЛицо);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Организация) И Не ЗначениеЗаполнено(ТекущаяСтрока.Сертификат) Тогда
			ПараметрыСертификата.Вставить("Организация", Организация);
		КонецЕсли;
		
		Попытка
			
			СсылкаНаСертификат = ЭлектроннаяПодпись.ЗаписатьСертификатВСправочник(ТекущаяСтрока.АдресСертификата, ПараметрыСертификата);
			ТекущаяСтрока.Сертификат = СсылкаНаСертификат;
			ТекущаяСтрока.Обновить = Ложь;
			
		Исключение
			
			СообщениеОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось записать сертификат %1: %2';
					|en = 'Cannot save the %1 certificate: %2'"), ТекущаяСтрока.Представление,
				ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
				
			ИндексСтроки = Сертификаты.Индекс(ТекущаяСтрока);
			ОбщегоНазначения.СообщитьПользователю(СообщениеОбОшибке,, "Сертификаты[" + ИндексСтроки + "].Представление");
			Успех = Ложь;
			
		КонецПопытки;
		
	КонецЦикла;
	
	Возврат Успех;
	
КонецФункции

&НаКлиенте
Асинх Процедура ЗаполнитьОписаниеДанныхСертификата(Результат, АдресСертификата) Экспорт
	
	Если Результат <> Истина Тогда
		РасширениеПодключено = Ложь;
		ЗаполнитьОписаниеДанныхСертификатаНаСервере(АдресСертификата);
		Возврат;
	ИначеЕсли РасширениеПодключено <> Истина Тогда
		РасширениеПодключено = Истина;
	КонецЕсли;
	
	СертификатКриптографии = Новый СертификатКриптографии;
	Ждать СертификатКриптографии.ИнициализироватьАсинх(ПолучитьИзВременногоХранилища(АдресСертификата));
	СвойстваСертификата = ЭлектроннаяПодписьКлиент.СвойстваСертификата(СертификатКриптографии);
	
	ЭлектроннаяПодписьСлужебныйКлиентСервер.ЗаполнитьОписаниеДанныхСертификата(
		СертификатОписаниеДанных, СвойстваСертификата);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьОписаниеДанныхСертификатаНаСервере(АдресСертификата)
	
	СертификатКриптографии = Новый СертификатКриптографии(ПолучитьИзВременногоХранилища(АдресСертификата));
	СвойстваСертификата = ЭлектроннаяПодпись.СвойстваСертификата(СертификатКриптографии);
	
	ЭлектроннаяПодписьСлужебныйКлиентСервер.ЗаполнитьОписаниеДанныхСертификата(
		СертификатОписаниеДанных, СвойстваСертификата);
		
КонецПроцедуры

#КонецОбласти