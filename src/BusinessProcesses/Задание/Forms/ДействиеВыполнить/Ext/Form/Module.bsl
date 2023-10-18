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
	
	// Для нового объекта выполняем код инициализации формы в ПриСозданииНаСервере.
	// Для существующего - в ПриЧтенииНаСервере.
	Если Объект.Ссылка.Пустая() Тогда
		ИнициализироватьФорму();
	КонецЕсли;

	ТекущийПользователь = Пользователи.ТекущийПользователь();
	
	// СтандартныеПодсистемы.РаботаСФайлами
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами") Тогда
		МодульРаботаСФайлами = ОбщегоНазначения.ОбщийМодуль("РаботаСФайлами");
		ПараметрыГиперссылки = МодульРаботаСФайлами.ГиперссылкаФайлов();
		ПараметрыГиперссылки.Размещение = "КоманднаяПанель";
		ПараметрыГиперссылки.Владелец = "Объект.БизнесПроцесс";
		МодульРаботаСФайлами.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыГиперссылки);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.РаботаСФайлами

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	БизнесПроцессыИЗадачиКлиент.ОбновитьДоступностьКомандПринятияКИсполнению(ЭтотОбъект);
	
	// СтандартныеПодсистемы.РаботаСФайлами
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами") Тогда
		МодульРаботаСФайламиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСФайламиКлиент");
		МодульРаботаСФайламиКлиент.ПриОткрытии(ЭтотОбъект, Отказ);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.РаботаСФайлами

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	ВыполнитьЗадачу = Ложь;
	Если Не (ПараметрыЗаписи.Свойство("ВыполнитьЗадачу", ВыполнитьЗадачу) И ВыполнитьЗадачу) Тогда
		Возврат;
	КонецЕсли;

	Если Не ЗаданиеВыполнено И Не ЗначениеЗаполнено(ТекущийОбъект.РезультатВыполнения) Тогда
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Укажите причину, по которой задача отклоняется.';
				|en = 'Please tell why you decline the task.'"),, 
			"Объект.РезультатВыполнения",, Отказ);
		Возврат;
	КонецЕсли;
	
	// Предварительная запись бизнес-процесса для корректной работы обработчика точки маршрута.
	ЗаписатьРеквизитыБизнесПроцесса(ТекущийОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	БизнесПроцессыИЗадачиКлиент.ФормаЗадачиОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	Если ИмяСобытия = "Запись_Задание" Тогда
		Если (Источник = Объект.БизнесПроцесс Или (ТипЗнч(Источник) = Тип("Массив") И Источник.Найти(
			Объект.БизнесПроцесс) <> Неопределено)) Тогда
			Прочитать();
		КонецЕсли;
	КонецЕсли;
	
	// СтандартныеПодсистемы.РаботаСФайлами
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами") Тогда
		МодульРаботаСФайламиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСФайламиКлиент");
		МодульРаботаСФайламиКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.РаботаСФайлами

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	ИнициализироватьФорму();
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СрокНачалаИсполненияПриИзменении(Элемент)

	Если Объект.ДатаНачала = НачалоДня(Объект.ДатаНачала) Тогда
		Объект.ДатаНачала = КонецДня(Объект.ДатаНачала);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ДатаИсполненияПриИзменении(Элемент)

	Если Объект.ДатаИсполнения = НачалоДня(Объект.ДатаИсполнения) Тогда
		Объект.ДатаИсполнения = КонецДня(Объект.ДатаИсполнения);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрытьВыполнить()

	БизнесПроцессыИЗадачиКлиент.ЗаписатьИЗакрытьВыполнить(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ПредметНажатие(Элемент, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	ПоказатьЗначение(, Объект.Предмет);

КонецПроцедуры

// СтандартныеПодсистемы.РаботаСФайлами
&НаКлиенте
Процедура Подключаемый_ПолеПредпросмотраНажатие(Элемент, СтандартнаяОбработка)

	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами") Тогда
		МодульРаботаСФайламиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСФайламиКлиент");
		МодульРаботаСФайламиКлиент.ПолеПредпросмотраНажатие(ЭтотОбъект, Элемент, СтандартнаяОбработка);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПолеПредпросмотраПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)

	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами") Тогда
		МодульРаботаСФайламиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСФайламиКлиент");
		МодульРаботаСФайламиКлиент.ПолеПредпросмотраПроверкаПеретаскивания(ЭтотОбъект, Элемент,
			ПараметрыПеретаскивания, СтандартнаяОбработка);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПолеПредпросмотраПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)

	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами") Тогда
		МодульРаботаСФайламиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСФайламиКлиент");
		МодульРаботаСФайламиКлиент.ПолеПредпросмотраПеретаскивание(ЭтотОбъект, Элемент, ПараметрыПеретаскивания,
			СтандартнаяОбработка);
	КонецЕсли;

КонецПроцедуры
// Конец СтандартныеПодсистемы.РаботаСФайлами

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполненоВыполнить(Команда)

	ЗаданиеВыполнено = Истина;
	БизнесПроцессыИЗадачиКлиент.ЗаписатьИЗакрытьВыполнить(ЭтотОбъект, Истина);

КонецПроцедуры

&НаКлиенте
Процедура Отменено(Команда)

	ЗаданиеВыполнено = Ложь;
	БизнесПроцессыИЗадачиКлиент.ЗаписатьИЗакрытьВыполнить(ЭтотОбъект, Истина);

КонецПроцедуры

&НаКлиенте
Процедура Дополнительно(Команда)

	БизнесПроцессыИЗадачиКлиент.ОткрытьДопИнформациюОЗадаче(Объект.Ссылка);

КонецПроцедуры

&НаКлиенте
Процедура ПринятьКИсполнению(Команда)

	БизнесПроцессыИЗадачиКлиент.ПринятьЗадачуКИсполнению(ЭтотОбъект, ТекущийПользователь);

КонецПроцедуры

&НаКлиенте
Процедура ОтменитьПринятиеКИсполнению(Команда)

	БизнесПроцессыИЗадачиКлиент.ОтменитьПринятиеЗадачиКИсполнению(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ИзменитьЗадание(Команда)

	Если Модифицированность Тогда
		Записать();
	КонецЕсли;
	ПоказатьЗначение(, Объект.БизнесПроцесс);

КонецПроцедуры

// СтандартныеПодсистемы.РаботаСФайлами
&НаКлиенте
Процедура Подключаемый_КомандаПанелиПрисоединенныхФайлов(Команда)

	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами") Тогда
		МодульРаботаСФайламиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСФайламиКлиент");
		МодульРаботаСФайламиКлиент.КомандаУправленияПрисоединеннымиФайлами(ЭтотОбъект, Команда);
	КонецЕсли;

КонецПроцедуры
// Конец СтандартныеПодсистемы.РаботаСФайлами

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ИнициализироватьФорму()

	НачальныйПризнакВыполнения = Объект.Выполнена;
	ПрочитатьРеквизитыБизнесПроцесса();
	УстановитьСостояниеЭлементов();

	ИспользоватьДатуИВремяВСрокахЗадач = ПолучитьФункциональнуюОпцию("ИспользоватьДатуИВремяВСрокахЗадач");
	Элементы.СрокНачалаИсполненияВремя.Видимость = ИспользоватьДатуИВремяВСрокахЗадач;
	Элементы.ДатаИсполненияВремя.Видимость = ИспользоватьДатуИВремяВСрокахЗадач;
	БизнесПроцессыИЗадачиСервер.УстановитьФорматДаты(Элементы.СрокИсполнения);
	БизнесПроцессыИЗадачиСервер.УстановитьФорматДаты(Элементы.Дата);

	БизнесПроцессыИЗадачиСервер.ФормаЗадачиПриСозданииНаСервере(ЭтотОбъект, Объект, Элементы.ГруппаСостояние,
		Элементы.ДатаИсполнения);
	Элементы.ОписаниеРезультата.ТолькоПросмотр = Объект.Выполнена;

	Элементы.ИзменитьЗадание.Видимость = (Объект.Автор = Пользователи.ТекущийПользователь());
	Исполнитель = ?(ЗначениеЗаполнено(Объект.Исполнитель), Объект.Исполнитель, Объект.РольИсполнителя);

	Если ПравоДоступа("Изменение", Метаданные.БизнесПроцессы.Задание) Тогда
		Элементы.Выполнено.Доступность = Истина;
		Элементы.Отклонено.Доступность = Истина;
	Иначе
		Элементы.Выполнено.Доступность = Ложь;
		Элементы.Отклонено.Доступность = Ложь;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПрочитатьРеквизитыБизнесПроцесса()

	ЗадачаОбъект = РеквизитФормыВЗначение("Объект");

	УстановитьПривилегированныйРежим(Истина);
	ЗаданиеОбъект = ЗадачаОбъект.БизнесПроцесс.ПолучитьОбъект();
	ЗаданиеВыполнено = ЗаданиеОбъект.Выполнено;
	ЗаданиеРезультатВыполнения = ЗаданиеОбъект.РезультатВыполнения;
	ЗаданиеСодержание = ЗаданиеОбъект.Содержание;

КонецПроцедуры

&НаСервере
Процедура ЗаписатьРеквизитыБизнесПроцесса(ЗадачаОбъект)

	УстановитьПривилегированныйРежим(Истина);
	НачатьТранзакцию();
	Попытка
		БизнесПроцессыИЗадачиСервер.ЗаблокироватьБизнесПроцессы(ЗадачаОбъект.БизнесПроцесс);

		БизнесПроцессОбъект = ЗадачаОбъект.БизнесПроцесс.ПолучитьОбъект();
		ЗаблокироватьДанныеДляРедактирования(БизнесПроцессОбъект.Ссылка);

		БизнесПроцессОбъект.Выполнено = ЗаданиеВыполнено;
		БизнесПроцессОбъект.Записать(); // АПК:1327 Блокировка установлена в БизнесПроцессыИЗадачиСервер.ЗаблокироватьБизнесПроцессы

		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
КонецПроцедуры

&НаСервере
Процедура УстановитьСостояниеЭлементов()

	БизнесПроцессы.Задание.УстановитьСостояниеЭлементовФормыЗадачи(ЭтотОбъект);

КонецПроцедуры

#КонецОбласти