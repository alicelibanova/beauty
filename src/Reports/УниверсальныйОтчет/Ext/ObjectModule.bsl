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

// СтандартныеПодсистемы.ВариантыОтчетов

// Задать настройки формы отчета.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения
//         - Неопределено
//   КлючВарианта - Строка
//                - Неопределено
//   Настройки - см. ОтчетыКлиентСервер.НастройкиОтчетаПоУмолчанию
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	Настройки.События.ПриСозданииНаСервере = Истина;
	Настройки.События.ПередЗагрузкойВариантаНаСервере = Истина;
	Настройки.События.ПередЗагрузкойНастроекВКомпоновщик = Истина;
	Настройки.События.ПриОпределенииПараметровВыбора = Истина;
	Настройки.События.ПриОпределенииСвойствЭлементовФормыНастроек = Истина;
	
	Настройки.РазрешеноЗагружатьСхему = Истина;
	Настройки.РазрешеноРедактироватьСхему = Истина;
	Настройки.РазрешеноВосстанавливатьСтандартнуюСхему = Истина;
	
	Настройки.ЗагрузитьНастройкиПриИзмененииПараметров = Отчеты.УниверсальныйОтчет.ЗагрузитьНастройкиПриИзмененииПараметров();
КонецПроцедуры

// См. ОтчетыПереопределяемый.ПриСозданииНаСервере
Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	РазрешеноИзменятьВарианты = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(
		Форма.НастройкиОтчета, "РазрешеноИзменятьВарианты", Ложь);
	
	Если РазрешеноИзменятьВарианты Тогда
		Форма.НастройкиОтчета.ФормаНастроекРасширенныйРежим = 1;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Форма.Элементы, "ВыбратьНастройки", "Видимость", Ложь);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Форма.Элементы, "СохранитьНастройки", "Видимость", Ложь);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Форма.Элементы, "ПоделитьсяНастройками", "Видимость", Ложь);
КонецПроцедуры

// См. ОтчетыПереопределяемый.ПриОпределенииПараметровВыбора.
Процедура ПриОпределенииПараметровВыбора(Форма, СвойстваНастройки) Экспорт
	ДоступныеЗначения = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(
		КомпоновщикНастроек.Настройки.ДополнительныеСвойства, "ДоступныеЗначения", Новый Структура);
	
	Попытка
		ЗначенияДляВыбора = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(
			ДоступныеЗначения, СтрЗаменить(СвойстваНастройки.ПолеКД, "ПараметрыДанных.", ""));
	Исключение
		ЗначенияДляВыбора = Неопределено;
	КонецПопытки;
	
	Если ЗначенияДляВыбора <> Неопределено Тогда 
		СвойстваНастройки.ОграничиватьВыборУказаннымиЗначениями = Истина;
		СвойстваНастройки.ЗначенияДляВыбора = ЗначенияДляВыбора;
	КонецЕсли;
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
// См. "Расширение управляемой формы для отчета.ПередЗагрузкойВариантаНаСервере" в синтакс-помощнике.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - форма отчета.
//   Настройки - НастройкиКомпоновкиДанных - настройки для загрузки в компоновщик настроек.
//   ПередЗагрузкойНастроек - Булево - Истина, если вызывается из процедуры ПередЗагрузкойНастроекВКомпоновщик.
//
Процедура ПередЗагрузкойВариантаНаСервере(Форма, Настройки, ПередЗагрузкойНастроек = Ложь) Экспорт
	ТекущийКлючСхемы = Неопределено;
	Схема = Неопределено;
	
	ЭтоЗагруженнаяСхема = Ложь;
	
	Если ТипЗнч(Настройки) = Тип("НастройкиКомпоновкиДанных") Или Настройки = Неопределено Тогда
		Если Настройки = Неопределено Тогда
			ДополнительныеСвойстваНастроек = КомпоновщикНастроек.Настройки.ДополнительныеСвойства;
		Иначе
			ДополнительныеСвойстваНастроек = Настройки.ДополнительныеСвойства;
		КонецЕсли;
		ЭтоОсновнойВариант = Форма.КлючТекущегоВарианта = "Основной"
			Или Форма.КлючТекущегоВарианта = "Main";
		
		Если Форма.ТипФормыОтчета = ТипФормыОтчета.Основная
			И (Форма.РежимРасшифровки Или Не ЭтоОсновнойВариант) Тогда 
			
			ДополнительныеСвойстваНастроек.Вставить("ОтчетИнициализирован", Истина);
		КонецЕсли;
		
		ДвоичныеДанныеСхемы = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(
			ДополнительныеСвойстваНастроек, "СхемаКомпоновкиДанных");
		
		Если ТипЗнч(ДвоичныеДанныеСхемы) = Тип("ДвоичныеДанные") Тогда
			ЭтоЗагруженнаяСхема = Истина;
			ТекущийКлючСхемы = ХешДвоичныхДанных(ДвоичныеДанныеСхемы);
			Схема = Отчеты.УниверсальныйОтчет.ИзвлечьСхемуИзДвоичныхДанных(ДвоичныеДанныеСхемы);
		КонецЕсли;
		
		ДополнительныеСвойстваНастроек.Удалить("УстановитьФиксированныеПараметры");
		ДополнительныеСвойстваНастроек.Удалить("ЗагруженныеНастройкиXML");
		
		Если Не ЭтоОсновнойВариант
		   И Не ПередЗагрузкойНастроек
		   И ТипЗнч(Настройки) = Тип("НастройкиКомпоновкиДанных")
		   И ДополнительныеСвойстваНастроек.Свойство("ДоступныеЗначения") Тогда
			
			Если ДополнительныеСвойстваНастроек.Свойство("СохраняемыеФиксированныеПараметры") Тогда
				ДополнительныеСвойстваНастроек.Вставить("УстановитьФиксированныеПараметры");
			Иначе
				ДополнительныеСвойстваНастроек.Вставить("ЗагруженныеНастройкиXML",
					ОбщегоНазначения.ЗначениеВСтрокуXML(Настройки));
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЭтоЗагруженнаяСхема Тогда
		КлючСхемы = ТекущийКлючСхемы;
		ОтчетыСервер.ПодключитьСхему(ЭтотОбъект, Форма, Схема, КлючСхемы);
	КонецЕсли;
КонецПроцедуры

// Вызывается перед загрузкой новых настроек. Используется для изменения СКД отчета.
//
// Параметры:
//   Контекст - Произвольный
//   КлючСхемы - Строка
//   КлючВарианта - Строка
//                - Неопределено
//   НовыеНастройкиКД - НастройкиКомпоновкиДанных
//                    - Неопределено
//   НовыеПользовательскиеНастройкиКД - ПользовательскиеНастройкиКомпоновкиДанных
//                                    - Неопределено
//
Процедура ПередЗагрузкойНастроекВКомпоновщик(Контекст, КлючСхемы, КлючВарианта, НовыеНастройкиКД, НовыеПользовательскиеНастройкиКД) Экспорт
	ТекущийКлючСхемы = Неопределено;
	
	Если НовыеНастройкиКД = Неопределено Тогда 
		НовыеНастройкиКД = КомпоновщикНастроек.Настройки;
	КонецЕсли;
	
	ЭтоЗагруженнаяСхема = Ложь;
	ДвоичныеДанныеСхемы = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(
		НовыеНастройкиКД.ДополнительныеСвойства, "СхемаКомпоновкиДанных");
	
	Если ТипЗнч(ДвоичныеДанныеСхемы) = Тип("ДвоичныеДанные") Тогда
		ТекущийКлючСхемы = ХешДвоичныхДанных(ДвоичныеДанныеСхемы);
		Если ТекущийКлючСхемы <> КлючСхемы Тогда
			Схема = Отчеты.УниверсальныйОтчет.ИзвлечьСхемуИзДвоичныхДанных(ДвоичныеДанныеСхемы);
			ЭтоЗагруженнаяСхема = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Если НовыеНастройкиКД.ДополнительныеСвойства.Свойство("УстановитьФиксированныеПараметры") Тогда
		НовыеНастройкиКД.ДополнительныеСвойства.Удалить("УстановитьФиксированныеПараметры");
		Попытка
			Отчеты.УниверсальныйОтчет.УстановитьФиксированныеПараметры(ЭтотОбъект,
				НовыеНастройкиКД.ДополнительныеСвойства.СохраняемыеФиксированныеПараметры,
				НовыеНастройкиКД,
				НовыеПользовательскиеНастройкиКД);
		Исключение
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			Комментарий = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Для варианта универсального отчета с ключом ""%1""
				           |не удалось установить фиксированные параметры по причине:
				           |%2';
				           |en = 'Cannot set fixed parameters
				           |for the universal report option with the ""%1"" key. Reason:
				           |%2'"),
				           КлючВарианта,
				           ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Варианты отчетов.Настройка параметров универсального отчета';
											|en = 'Report options.Set up universal report parameters'", 
				ОбщегоНазначения.КодОсновногоЯзыка()),
				УровеньЖурналаРегистрации.Ошибка,
				Метаданные.Справочники.ВариантыОтчетов,,
				Комментарий);
		КонецПопытки;
		
	ИначеЕсли Не НовыеНастройкиКД.ДополнительныеСвойства.Свойство("ОтчетИнициализирован")
	        И ТипЗнч(НовыеПользовательскиеНастройкиКД) = Тип("ПользовательскиеНастройкиКомпоновкиДанных") Тогда
		
		// Переустановка схемы при загрузке основного варианта отчета
		// (в том числе при сбросе настроек к настройкам по умолчанию).
		КлючСхемы = "";
	КонецЕсли;
	
	ДоступныеЗначения = Неопределено;
	ФиксированныеПараметры = Отчеты.УниверсальныйОтчет.ФиксированныеПараметры(
		НовыеНастройкиКД, НовыеПользовательскиеНастройкиКД, ДоступныеЗначения);
	
	Если НовыеНастройкиКД.ДополнительныеСвойства.Свойство("ЗагруженныеНастройкиXML") Тогда
		ЗагруженныеНастройкиXML = НовыеНастройкиКД.ДополнительныеСвойства.ЗагруженныеНастройкиXML;
		НовыеНастройкиКД.ДополнительныеСвойства.Удалить("ЗагруженныеНастройкиXML");
		Попытка
			ЗагруженныеНастройкиКД = ОбщегоНазначения.ЗначениеИзСтрокиXML(ЗагруженныеНастройкиXML);
			ЗагруженныеНастройкиКД.ДополнительныеСвойства.Вставить("ДоступныеЗначения", ДоступныеЗначения);
			ЗагруженныеНастройкиКД.ДополнительныеСвойства.Вставить("СохраняемыеФиксированныеПараметры", ФиксированныеПараметры);
			КлючОтчета = Контекст.НастройкиОтчета.ПолноеИмя;
			ОписаниеНастроек = ХранилищаНастроек.ХранилищеВариантовОтчетов.ПолучитьОписание(КлючОтчета, КлючВарианта);
			ХранилищаНастроек.ХранилищеВариантовОтчетов.Сохранить(КлючОтчета,
				КлючВарианта, ЗагруженныеНастройкиКД, ОписаниеНастроек);
		Исключение
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			Комментарий = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Для варианта универсального отчета с ключом ""%1""
				           |не удалось записать фиксированные параметры по причине:
				           |%2';
				           |en = 'Cannot save the fixed parameters
				           |for the universal report option with the ""%1"" key. Reason:
				           |%2'"),
				           КлючВарианта,
				           ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Варианты отчетов.Настройка параметров универсального отчета';
											|en = 'Report options.Set up universal report parameters'", 
				ОбщегоНазначения.КодОсновногоЯзыка()),
				УровеньЖурналаРегистрации.Ошибка,
				Метаданные.Справочники.ВариантыОтчетов,,
				Комментарий);
		КонецПопытки;
	КонецЕсли;
	
	Если ТекущийКлючСхемы = Неопределено Тогда 
		ТекущийКлючСхемы = ФиксированныеПараметры.ТипОбъектаМетаданных
			+ "/" + ФиксированныеПараметры.ИмяОбъектаМетаданных
			+ "/" + ФиксированныеПараметры.ИмяТаблицы;
		ТекущийКлючСхемы = ОбщегоНазначения.СократитьСтрокуКонтрольнойСуммой(ТекущийКлючСхемы, 100);
		
		Если ТекущийКлючСхемы <> КлючСхемы Тогда
			КлючСхемы = "";
		КонецЕсли;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(КлючСхемы) И Не ЭтоЗагруженнаяСхема Тогда
		Схема = Отчеты.УниверсальныйОтчет.СхемаКомпоновкиДанных(ФиксированныеПараметры);
	КонецЕсли;
	
	Если ТекущийКлючСхемы <> Неопределено И (ТекущийКлючСхемы <> КлючСхемы) Тогда
		КлючСхемы = ТекущийКлючСхемы;
		ОтчетыСервер.ПодключитьСхему(ЭтотОбъект, Контекст, Схема, КлючСхемы);
		
		Если ЭтоЗагруженнаяСхема Тогда
			Отчеты.УниверсальныйОтчет.УстановитьСтандартныеНастройкиЗагруженнойСхемы(
				ЭтотОбъект, ДвоичныеДанныеСхемы, НовыеНастройкиКД, НовыеПользовательскиеНастройкиКД);
		Иначе
			Отчеты.УниверсальныйОтчет.УстановитьСтандартныеНастройки(
				ЭтотОбъект, ФиксированныеПараметры, НовыеНастройкиКД, НовыеПользовательскиеНастройкиКД);
		КонецЕсли;
		
		Если ТипЗнч(Контекст) = Тип("ФормаКлиентскогоПриложения") Тогда
			// Переопределение.
			ИнтеграцияПодсистемБСП.ПередЗагрузкойВариантаНаСервере(Контекст, НовыеНастройкиКД);
			ОтчетыПереопределяемый.ПередЗагрузкойВариантаНаСервере(Контекст, НовыеНастройкиКД);
			ПередЗагрузкойВариантаНаСервере(Контекст, НовыеНастройкиКД, Истина);
			
			ИспользуемыеТаблицы = ВариантыОтчетов.ИспользуемыеТаблицы(СхемаКомпоновкиДанных);
			ИспользуемыеТаблицы.Добавить(Метаданные().ПолноеИмя());
			Контекст.НастройкиОтчета.Вставить("ИспользуемыеТаблицы", ИспользуемыеТаблицы);
		ИначеЕсли ТипЗнч(Контекст) = Тип("Структура") Тогда
			АдресСхемы = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Контекст, "АдресСхемы");
			Если Не ЭтоАдресВременногоХранилища(АдресСхемы) Тогда 
				Контекст.Вставить("АдресСхемы", ПоместитьВоВременноеХранилище(Схема, Новый УникальныйИдентификатор));
			КонецЕсли;
		КонецЕсли;
		ДоступныеЗначения = Неопределено;
		ФиксированныеПараметры = Отчеты.УниверсальныйОтчет.ФиксированныеПараметры(
			НовыеНастройкиКД, НовыеПользовательскиеНастройкиКД, ДоступныеЗначения);
	Иначе
		Отчеты.УниверсальныйОтчет.УстановитьФиксированныеПараметры(
			ЭтотОбъект, ФиксированныеПараметры, НовыеНастройкиКД, НовыеПользовательскиеНастройкиКД);
	КонецЕсли;
	НовыеНастройкиКД.ДополнительныеСвойства.Вставить("СохраняемыеФиксированныеПараметры", ФиксированныеПараметры);
	НовыеНастройкиКД.ДополнительныеСвойства.Вставить("ДоступныеЗначения", ДоступныеЗначения);
	
	Отчеты.УниверсальныйОтчет.УстановитьСтандартныйЗаголовокОтчета(
		Контекст, НовыеНастройкиКД, ФиксированныеПараметры, ДоступныеЗначения);
КонецПроцедуры

// Вызывается после определения свойств элементов формы, связанных с пользовательскими настройками.
// См. ОтчетыСервер.СвойстваЭлементовФормыНастроек()
// Позволяет переопределить свойства, для целей персонализации отчета.
//
// Параметры:
//  ТипФормы - ТипФормыОтчета - см. Синтакс-помощник
//  СвойстваЭлементов - см. ОтчетыСервер.СвойстваЭлементовФормыНастроек
//  ПользовательскиеНастройки - КоллекцияЭлементовПользовательскихНастроекКомпоновкиДанных - элементы актуальных
//                              пользовательских настроек, влияющих на создание связанных элементов формы.
//
Процедура ПриОпределенииСвойствЭлементовФормыНастроек(ТипФормы, СвойстваЭлементов, ПользовательскиеНастройки) Экспорт 
	Если ТипФормы <> ТипФормыОтчета.Основная Тогда 
		Возврат;
	КонецЕсли;
	
	СвойстваГруппы = ОтчетыСервер.СвойстваГруппыЭлементовФормы();
	СвойстваГруппы.Группировка = ГруппировкаПодчиненныхЭлементовФормы.ГоризонтальнаяВсегда;
	СвойстваЭлементов.Группы.Вставить("ФиксированныеПараметры", СвойстваГруппы);
	
	ФиксированныеПараметры = Новый Структура("Период, ТипОбъектаМетаданных, ИмяОбъектаМетаданных, ИмяТаблицы");
	ШиринаПоля = Новый Структура("ТипОбъектаМетаданных, ИмяОбъектаМетаданных, ИмяТаблицы", 20, 35, 20);
	
	Для Каждого ЭлементНастройки Из ПользовательскиеНастройки Цикл 
		Если ТипЗнч(ЭлементНастройки) <> Тип("ЗначениеПараметраНастроекКомпоновкиДанных")
			Или Не ФиксированныеПараметры.Свойство(ЭлементНастройки.Параметр) Тогда 
			Продолжить;
		КонецЕсли;
		
		СвойстваПоля = СвойстваЭлементов.Поля.Найти(
			ЭлементНастройки.ИдентификаторПользовательскойНастройки, "ИдентификаторНастройки");
		
		Если СвойстваПоля = Неопределено Тогда 
			Продолжить;
		КонецЕсли;
		
		СвойстваПоля.ИдентификаторГруппы = "ФиксированныеПараметры";
		
		ИмяПараметра = Строка(ЭлементНастройки.Параметр);
		Если ИмяПараметра <> "Период" Тогда 
			СвойстваПоля.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
			СвойстваПоля.Ширина = ШиринаПоля[ИмяПараметра];
			СвойстваПоля.РастягиватьПоГоризонтали = Ложь;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	Настройки = КомпоновщикНастроек.ПолучитьНастройки();
	
	Отчеты.УниверсальныйОтчет.ВывестиКоличествоПодчиненныхЗаписей(Настройки, СхемаКомпоновкиДанных, СтандартнаяОбработка);
	
	Если СтандартнаяОбработка Тогда 
		Возврат;
	КонецЕсли;
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, Настройки, ДанныеРасшифровки);
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки,, ДанныеРасшифровки);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает хеш-сумму двоичных данных.
//
// Параметры:
//   ДвоичныеДанные - ДвоичныеДанные - данные, от которых считается хеш-сумма.
//
Функция ХешДвоичныхДанных(ДвоичныеДанные)
	ХешированиеДанных = Новый ХешированиеДанных(ХешФункция.MD5);
	ХешированиеДанных.Добавить(ДвоичныеДанные);
	Возврат СтрЗаменить(ХешированиеДанных.ХешСумма, " ", "") + "_" + Формат(ДвоичныеДанные.Размер(), "ЧГ=");
КонецФункции

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.';
						|en = 'Invalid object call on the client.'");
#КонецЕсли