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
	
	Если ЗначениеЗаполнено(Параметры.ВладелецФайла) Тогда 
		Список.Параметры.УстановитьЗначениеПараметра(
			"Владелец", Параметры.ВладелецФайла);
	
		Если ТипЗнч(Параметры.ВладелецФайла) = Тип("СправочникСсылка.ПапкиФайлов") Тогда
			Элементы.Папки.ТекущаяСтрока = Параметры.ВладелецФайла;
			Элементы.Папки.ВыделенныеСтроки.Очистить();
			Элементы.Папки.ВыделенныеСтроки.Добавить(Элементы.Папки.ТекущаяСтрока);
		Иначе
			Элементы.Папки.Видимость = Ложь;
		КонецЕсли;
	Иначе
		Если Параметры.ВыборШаблона Тогда
			
			ОпределитьВозможностьДобавлениеШаблоновФайлов();
			
			РежимВыбораШаблона = Параметры.ВыборШаблона;
			
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
				Папки, "Ссылка", Справочники.ПапкиФайлов.Шаблоны,
				ВидСравненияКомпоновкиДанных.ВИерархии, , Истина);
			
			Элементы.Папки.ТекущаяСтрока = Справочники.ПапкиФайлов.Шаблоны;
			Элементы.Папки.ВыделенныеСтроки.Очистить();
			Элементы.Папки.ВыделенныеСтроки.Добавить(Элементы.Папки.ТекущаяСтрока);
		КонецЕсли;
		
		Список.Параметры.УстановитьЗначениеПараметра("Владелец", Элементы.Папки.ТекущаяСтрока);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.ТекущаяСтрока) Тогда 
		Элементы.Папки.ТекущаяСтрока = Параметры.ТекущаяСтрока;
	КонецЕсли;
	
	ПриИзмененияИспользованияПодписанияИлиШифрованияНаСервере();
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		Элементы.Папки.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Авто;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_Файл" И Параметр.Свойство("ЭтоНовый") И Параметр.ЭтоНовый Тогда
		
		Если Параметр <> Неопределено Тогда
			ВладелецФайла = Неопределено;
			Если Параметр.Свойство("Владелец", ВладелецФайла) Тогда
				Если ВладелецФайла = Элементы.Папки.ТекущаяСтрока Тогда
					Элементы.Список.Обновить();
					
					ФайлСозданный = Неопределено;
					Если Параметр.Свойство("Файл", ФайлСозданный) Тогда
						Элементы.Список.ТекущаяСтрока = ФайлСозданный;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		Элементы.Список.Обновить();
		
	КонецЕсли;
	
	Если ВРег(ИмяСобытия) = ВРег("Запись_НаборКонстант")
		И (    ВРег(Источник) = ВРег("ИспользоватьЭлектронныеПодписи")
		Или ВРег(Источник) = ВРег("ИспользоватьШифрование")) Тогда
		
		ПодключитьОбработчикОжидания("ПриИзмененияИспользованияПодписанияИлиШифрования", 0.3, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
#Если МобильныйКлиент Тогда
	УстановитьЗаголовокДереваПапок();
#КонецЕсли

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПапки

&НаКлиенте
Процедура ПапкиПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("ОбработкаОжидания", 0.2, Истина);
	
#Если МобильныйКлиент Тогда
	ПодключитьОбработчикОжидания("УстановитьЗаголовокДереваПапок", 0.1, Истина);
	ТекущийЭлемент = Элементы.Список;
#КонецЕсли

КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	Если Не Копирование Тогда
		ДобавитьФайлВПрограмму();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередУдалением(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ДобавитьФайл(Команда)
	
	ДобавитьФайлВПрограмму();
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьФайлВПрограмму()
	
	Если РежимВыбораШаблона Тогда
		
		РаботаСФайламиСлужебныйКлиент.ДобавитьФайлИзФайловойСистемы(Элементы.Папки.ТекущаяСтрока, ЭтотОбъект);
		
	Иначе
		
		ЗначениеПараметраКД = Список.Параметры.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Владелец"));
		Если ЗначениеПараметраКД = Неопределено Тогда
			ВладелецФайла = Неопределено;
		Иначе
			ВладелецФайла = ЗначениеПараметраКД.Значение;
		КонецЕсли;
		РаботаСФайламиСлужебныйКлиент.ДобавитьФайл(Неопределено, ВладелецФайла, ЭтотОбъект);
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура обновляет список Файлов.
&НаКлиенте
Процедура ОбработкаОжидания()
	
	Если Элементы.Папки.ТекущаяСтрока <> Неопределено Тогда
		Список.Параметры.УстановитьЗначениеПараметра("Владелец", Элементы.Папки.ТекущаяСтрока);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененияИспользованияПодписанияИлиШифрования()
	
	ПриИзмененияИспользованияПодписанияИлиШифрованияНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьЗаголовокДереваПапок()
	
	Элементы.Папки.Заголовок = ?(Элементы.Папки.ТекущиеДанные = Неопределено, "",
		Элементы.Папки.ТекущиеДанные.Наименование);
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененияИспользованияПодписанияИлиШифрованияНаСервере()
	
	РаботаСФайламиСлужебный.КриптографияПриСозданииФормыНаСервере(ЭтотОбъект,, Истина);
	
КонецПроцедуры

&НаСервере
Процедура ОпределитьВозможностьДобавлениеШаблоновФайлов()
	
	Перем ЕстьПравоДобавлениеФайлов, МодульУправлениеДоступом;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		ЕстьПравоДобавлениеФайлов = МодульУправлениеДоступом.ЕстьПраво("ДобавлениеФайлов", Справочники.ПапкиФайлов.Шаблоны);
	Иначе
		ЕстьПравоДобавлениеФайлов = ПравоДоступа("Добавление", Метаданные.Справочники.Файлы) И ПравоДоступа("Чтение", Метаданные.Справочники.ПапкиФайлов);
	КонецЕсли;
	
	Если Не ЕстьПравоДобавлениеФайлов Тогда
		Элементы.ДобавитьФайл.Видимость = Ложь;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти
