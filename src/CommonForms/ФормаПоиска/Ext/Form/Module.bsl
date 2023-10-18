﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных
&НаКлиенте
Перем НаправлениеПоискаЗначение;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Пользователи.ЭтоСеансВнешнегоПользователя() Тогда
		Возврат;
	КонецЕсли;
		
	СостояниеПоиска = ПолнотекстовыйПоискСервер.СостояниеПолнотекстовогоПоиска();
	ЗагрузитьНастройкиИИсториюПоиска();
	
	Если Не ПустаяСтрока(Параметры.ПереданнаяСтрокаПоиска) Тогда
		СтрокаПоиска = Параметры.ПереданнаяСтрокаПоиска;
		ПриВыполненииПоискаНаСервере(СтрокаПоиска);
	Иначе	
		ОбновитьФорму(Новый Массив);
	КонецЕсли;
	
	ОбновитьПредставлениеОбластиПоиска();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ПользователиКлиент.ЭтоСеансВнешнегоПользователя() Тогда 
		Отказ = Истина;
		ПоказатьПредупреждение(, НСтр("ru = 'Недостаточно прав для выполнения поиска';
										|en = 'Insufficient rights to search'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СтрокаПоискаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
#Если ВебКлиент Тогда
	Если Элементы.СтрокаПоиска.СписокВыбора.Количество() = 1 Тогда
		ВыбранноеЗначение = Элемент.ТекстРедактирования;
	КонецЕсли;
#КонецЕсли
	
	СтрокаПоиска = ВыбранноеЗначение;
	ПриВыполненииПоиска("ПерваяЧасть");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбластиПоискаПредставлениеНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ОбластиПоиска",   ОбластиПоиска);
	ПараметрыОткрытия.Вставить("ИскатьВРазделах", ИскатьВРазделах);
	
	Оповещение = Новый ОписаниеОповещения("ПослеПолученияНастроекОбластиПоиска", ЭтотОбъект);
	
	ОткрытьФорму("Обработка.ПолнотекстовыйПоискВДанных.Форма.ВыборОбластиПоиска",
		ПараметрыОткрытия,,,,, Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура HTMLТекстПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СсылкаHTML = ДанныеСобытия.Anchor;
	
	Если СсылкаHTML = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ПослеОткрытияНавигационнойСсылки", ЭтотОбъект);
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(СсылкаHTML.href, Оповещение);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьПоиск(Команда)
	
	ПриВыполненииПоиска("ПерваяЧасть");
	
КонецПроцедуры

&НаКлиенте
Процедура Предыдущие(Команда)
	
	ПриВыполненииПоиска("ПредыдущаяЧасть");
	
КонецПроцедуры

&НаКлиенте
Процедура Следующие(Команда)
	
	ПриВыполненииПоиска("СледующаяЧасть");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область СлужебныеОбработчикиСобытий

&НаКлиенте
Процедура ПослеПолученияНастроекОбластиПоиска(Результат, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Структура") Тогда
		ПриУстановкеОбластиПоиска(Результат);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриУстановкеОбластиПоиска(НастройкиОбластиПоиска)
	
	СохранитьНастройкиПоиска(НастройкиОбластиПоиска.ИскатьВРазделах, НастройкиОбластиПоиска.ОбластиПоиска);
	ОбластиПоиска = НастройкиОбластиПоиска.ОбластиПоиска;
	ИскатьВРазделах = НастройкиОбластиПоиска.ИскатьВРазделах;
	ОбновитьПредставлениеОбластиПоиска();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриВыполненииПоиска(Знач НаправлениеПоиска)
	
	Если ПустаяСтрока(СтрокаПоиска) Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Введите, что нужно найти.';
										|en = 'Enter search text.'"));
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначенияСлужебныйКлиент.ЭтоНавигационнаяСсылка(СтрокаПоиска) Тогда
		ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(СтрокаПоиска);
		СтрокаПоиска = "";
		Возврат;
	КонецЕсли;
	
	НаправлениеПоискаЗначение = НаправлениеПоиска;
	ПодключитьОбработчикОжидания("ПриВыполненииПоискаЗавершение", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриВыполненииПоискаЗавершение()
	
	ПриВыполненииПоискаНаСервере(СтрокаПоиска, НаправлениеПоискаЗначение);
	
КонецПроцедуры

&НаСервере
Процедура ПриВыполненииПоискаНаСервере(Знач СтрокаПоиска, Знач НаправлениеПоиска = "ПерваяЧасть")
	
	СохранитьСтрокуПоискаВИстории(СтрокаПоиска);
	
	ПараметрыПоиска = ПолнотекстовыйПоискСервер.ПараметрыПоиска();
	ПараметрыПоиска.ТекущаяПозиция = ТекущаяПозиция;
	ПараметрыПоиска.ИскатьВРазделах = ИскатьВРазделах;
	ПараметрыПоиска.ОбластиПоиска = ОбластиПоиска;
	ПараметрыПоиска.СтрокаПоиска = СтрокаПоиска;
	ПараметрыПоиска.НаправлениеПоиска = НаправлениеПоиска;
	
	РезультатПоиска = ПолнотекстовыйПоискСервер.ВыполнитьПолнотекстовыйПоиск(ПараметрыПоиска);
	ТекущаяПозиция = РезультатПоиска.ТекущаяПозиция;
	Количество = РезультатПоиска.Количество;
	ПолноеКоличество = РезультатПоиска.ПолноеКоличество;
	КодОшибки = РезультатПоиска.КодОшибки;
	ОписаниеОшибки = РезультатПоиска.ОписаниеОшибки;
	
	СостояниеПоиска = ПолнотекстовыйПоискСервер.СостояниеПолнотекстовогоПоиска();
	ОбновитьФорму(РезультатПоиска.РезультатыПоиска);

КонецПроцедуры

&НаКлиенте
Процедура ПослеОткрытияНавигационнойСсылки(ПриложениеЗапущено, Контекст) Экспорт
	
	Если Не ПриложениеЗапущено Тогда 
		ПоказатьПредупреждение(, НСтр("ru = 'Открытие объектов данного типа не предусмотрено';
										|en = 'Cannot open objects of this type'"));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Представления

&НаСервере
Процедура ОбновитьФорму(РезультатыПоиска)
	
	Если Количество = 0 Тогда
		Элементы.Следующие.Доступность  = Ложь;
		Элементы.Предыдущие.Доступность = Ложь;
	Иначе
		Элементы.Следующие.Доступность  = (ПолноеКоличество - ТекущаяПозиция) > Количество;
		Элементы.Предыдущие.Доступность = (ТекущаяПозиция > 0);
	КонецЕсли;
	
	Если Количество <> 0 Тогда
		ИнформацияОНайденномПредставление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Показаны %1 - %2 из %3';
				|en = 'Results %1–%2 out of %3'"),
			Формат(ТекущаяПозиция + 1, "ЧН=0; ЧГ="),
			Формат(ТекущаяПозиция + Количество, "ЧН=0; ЧГ="),
			Формат(ПолноеКоличество, "ЧН=0; ЧГ="));
	Иначе		
		ИнформацияОНайденномПредставление = "";
	КонецЕсли;
	
	Если ПустаяСтрока(КодОшибки) Тогда 
		РезультатыПоискаПредставление = НоваяHTMLСтраницаРезультата(РезультатыПоиска);
	Иначе 
		РезультатыПоискаПредставление = НоваяHTMLСтраницаОшибки();
	КонецЕсли;
	
	Если СостояниеПоиска = "ПоискРазрешен" Тогда 
		СостояниеПоискаПредставление = "";
	ИначеЕсли СостояниеПоиска = "ВыполняетсяОбновлениеИндекса"
		Или СостояниеПоиска = "ВыполняетсяСлияниеИндекса"
		Или СостояниеПоиска = "ТребуетсяОбновлениеИндекса" Тогда 
		
		СостояниеПоискаПредставление = НСтр("ru = 'Результаты поиска могут быть неточными, повторите поиск позднее.';
											|en = 'Search results might be inaccurate. Try the search later.'");
	ИначеЕсли СостояниеПоиска = "ОшибкаНастройкиПоиска" Тогда 
		
		// Для не администратора
		СостояниеПоискаПредставление = НСтр("ru = 'Полнотекстовый поиск не настроен, обратитесь к администратору.';
											|en = 'Full-text search is not set up. Contact your administrator.'");
		
	ИначеЕсли СостояниеПоиска = "ПоискЗапрещен" Тогда 
		СостояниеПоискаПредставление = НСтр("ru = 'Полнотекстовый поиск отключен.';
											|en = 'Full-text search is disabled.'");
	КонецЕсли;
	
	Элементы.СостояниеПоиска.Видимость = (СостояниеПоиска <> "ПоискРазрешен");

КонецПроцедуры

&НаСервере
Процедура ОбновитьПредставлениеОбластиПоиска()
	
	УказаныОбластиПоиска = ОбластиПоиска.Количество() > 0;
	
	Если Не ИскатьВРазделах Или Не УказаныОбластиПоиска Тогда
		ОбластиПоискаПредставление = НСтр("ru = 'Везде';
											|en = 'Everywhere'");
		Возврат;
	КонецЕсли;
	
	Если ОбластиПоиска.Количество() < 5 Тогда
		ОбластиПоискаПредставление = "";
		Для каждого Область Из ОбластиПоиска Цикл
			ОбъектМетаданных = ОбщегоНазначения.ОбъектМетаданныхПоИдентификатору(Область.Значение);
			ОбластиПоискаПредставление = ОбластиПоискаПредставление + ОбщегоНазначения.ПредставлениеСписка(ОбъектМетаданных) + ", ";
		КонецЦикла;
		ОбластиПоискаПредставление = Лев(ОбластиПоискаПредставление, СтрДлина(ОбластиПоискаПредставление) - 2);
	Иначе	
		ОбластиПоискаПредставление = НСтр("ru = 'В выбранных разделах';
											|en = 'In selected sections'");
	КонецЕсли;
	
КонецПроцедуры

// Параметры:
//  РезультатыПоиска - Массив из Структура:
//    * Ссылка - Строка
//    * ОписаниеHTML - Строка
//    * Представление - Строка
//
// Возвращаемое значение:
//  Строка
//
&НаСервере
Функция НоваяHTMLСтраницаРезультата(РезультатыПоиска)
	
	ШаблонСтраницы = 
		"<html>
		|<head>
		|  <meta http-equiv=""Content-Type"" content=""text/html; charset=UTF-8"">
		|  <style type=""text/css"">
		|    html {
		|      overflow: auto;
		|    }
		|    body {
		|      margin: 10px;
		|      font-family: Arial, sans-serif;
		|      font-size: 10pt;
		|      overflow: auto;
		|      position: absolute;
		|      top: 0;
		|      left: 0;
		|      bottom: 0;
		|      right: 0;
		|    }
		|    div.main {
		|      overflow: auto;
		|      height: 100%;
		|    }
		|    div.presentation {
		|      font-size: 11pt;
		|    }
		|    div.textPortion {
		|      padding-bottom: 16px;
		|    }
		|    span.bold {
		|      font-weight: bold;
		|    }
		|    ol li {
		|      color: #B3B3B3;
		|    }
		|    ol li div {
		|      color: #333333;
		|    }
		|    a {
		|      text-decoration: none;
		|      color: #0066CC;
		|    }
		|    a:hover {
		|      text-decoration: underline;
		|    }
		|    .gray {
		|      color: #B3B3B3;
		|    }
		|  </style>
		|</head>
		|<body>
		|  <div class=""main"">
		|    <ol start=""%ТекущаяПозиция%"">
		|%Строки%
		|    </ol>
		|  </div>
		|</body>
		|</html>";
	
	ШаблонСтроки = 
		"      <li>
		|        <div class=""presentation""><a href=""%Ссылка%"">%Представление%</a></div>
		|        %ОписаниеHTML%
		|      </li>";
	
	ШаблонНеактивнойСтроки = 
		"      <li>
		|        <div class=""presentation""><a href=""#"" class=""gray"">%Представление%</a></div>
		|        %ОписаниеHTML%
		|      </li>";
	
	Строки = "";
	
	Для каждого СтрокаРезультатаПоиска Из РезультатыПоиска Цикл 
		
		Ссылка        = СтрокаРезультатаПоиска.Ссылка;
		Представление = СтрокаРезультатаПоиска.Представление;
		ОписаниеHTML  = СтрокаРезультатаПоиска.ОписаниеHTML;
		
		Если Ссылка = "#" Тогда 
			Строка = ШаблонНеактивнойСтроки;
		Иначе 
			Строка = СтрЗаменить(ШаблонСтроки, "%Ссылка%", Ссылка);
		КонецЕсли;
		
		Строка = СтрЗаменить(Строка, "%Представление%", Представление);
		Строка = СтрЗаменить(Строка, "%ОписаниеHTML%",  ОписаниеHTML);
		
		Строки = Строки + Строка;
		
	КонецЦикла;
	
	HTMLСтраница = СтрЗаменить(ШаблонСтраницы, "%Строки%", Строки);
	HTMLСтраница = СтрЗаменить(HTMLСтраница  , "%ТекущаяПозиция%", ТекущаяПозиция + 1);
	
	Возврат HTMLСтраница;
	
КонецФункции

&НаСервере
Функция НоваяHTMLСтраницаОшибки()
	
	ШаблонСтраницы = 
		"<html>
		|<head>
		|  <meta http-equiv=""Content-Type"" content=""text/html; charset=UTF-8"">
		|  <style type=""text/css"">
		|    html { 
		|      overflow:auto;
		|    }
		|    body {
		|      margin: 10px;
		|      font-family: Arial, sans-serif;
		|      font-size: 10pt;
		|      overflow: auto;
		|      position: absolute;
		|      top: 0;
		|      left: 0;
		|      bottom: 0;
		|      right: 0;
		|    }
		|    div.main {
		|      overflow: auto;
		|      height: 100%;
		|    }
		|    div.error {
		|      font-size: 12pt;
		|    }
		|    div.presentation {
		|      font-size: 11pt;
		|    }
		|    h3 {
		|      color: #009646
		|    }
		|    li {
		|      padding-bottom: 16px;
		|    }
		|    a {
		|      text-decoration: none;
		|      color: #0066CC;
		|    }
		|    a:hover {
		|      text-decoration: underline;
		|    }
		|  </style>
		|</head>
		|<body>
		|  <div class=""main"">
		|    <div class=""error"">%1</div>
		|    <p>%2</p>
		|  </div>
		|</body>
		|</html>";
	
	РекомендацииHTML = 
		НСтр("ru = '<h3>Рекомендации:</h3>
			|<ul>
			|  %1
			|  %2
			|  <li>
			|    <b>Воспользуйтесь поиском по началу слова.</b><br>
			|    Используйте звездочку (*) в качестве окончания.<br>
			|    Например, поиск стро* найдет все документы, которые содержат слова, начинающиеся на стро - 
			|    Журнал ""Строительство и ремонт"", ""ООО СтройКомплект"" и.т.д.
			|  </li>
			|  <li>
			|    <b>Воспользуйтесь нечетким поиском.</b><br>
			|    Используйте решетку (#).<br>
			|    Например, Ромашка#2 найдет все документы, содержащие такие слова, которые отличаются от слова 
			|    Ромашка на одну или две буквы.
			|  </li>
			|</ul>
			|<div class ""presentation""><a href=""%3"">Полное описание формата поисковых выражений</a></div>';
			|en = '<h3>Recommended:</h3>
			|<ul>
			|  %1
			|  %2
			|  <li>
			|    <b>Search by beginning of a word.</b><br>
			|    Use asterisk (*) as a wildcat symbol.<br>
			|    For example, a search for cons* will find all documents containing words that start with the same letters:
			|    Construction and Repair, Construction Works Ltd, and so on.
			|  </li>
			|  <li>
			|    <b>Fuzzy search.</b><br>
			|    For fuzzy search, use the number sign (#).<br>
			|    For example, a search for Child#3 will find all documents containing words that differ from the word 
			|    Child by one, two, or three letters.
			|   </li>
			|</ul>
			|<div class ""presentation""><a href=""%3"">Searching with regular expressions</a></div>'");
	
	УказаныОбластиПоиска = ОбластиПоиска.Количество() > 0;
	
	РекомендацияОбластиПоискаHTML = "";
	РекомендацияТекстЗапросаHTML = "";
	
	Если КодОшибки = "НичегоНеНайдено" Тогда 
		
		Если ИскатьВРазделах И УказаныОбластиПоиска Тогда 
		
			РекомендацияОбластиПоискаHTML = 
				НСтр("ru = '<li><b>Уточните область поиска.</b><br>
					|Попробуйте выбрать больше областей поиска или все разделы.</li>';
					|en = '<li><b>Refine the search.</b><br>
					|Try to select other locations.</li>'");
		КонецЕсли;
		
		РекомендацияТекстЗапросаHTML =
			НСтр("ru = '<li><b>Упростите запрос, исключив из него какое-либо слово.</b></li>';
				|en = '<li><b>Try searching for fewer words.</b></li>'");
		
	ИначеЕсли КодОшибки = "СлишкомМногоРезультатов" Тогда
		
		Если Не ИскатьВРазделах Или Не УказаныОбластиПоиска Тогда 
			
			РекомендацияОбластиПоискаHTML = 
			НСтр("ru = '<li><b>Уточните область поиска.</b><br>
				|Попробуйте выбрать область поиска, задав точный раздел или список.</li>';
				|en = '<li><b>Refine the search.</b><br>
				|Try to select a location or list.</li>'");
		КонецЕсли;
		
	КонецЕсли;
	
	РекомендацииHTML = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(РекомендацииHTML, 
		РекомендацияОбластиПоискаHTML, РекомендацияТекстЗапросаHTML,
		"v8help://1cv8/QueryLanguageFullTextSearchInData");
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСтраницы, ОписаниеОшибки, РекомендацииHTML);
	
КонецФункции

#КонецОбласти

#Область ИсторияНастройкиПоиска

&НаСервере
Процедура ЗагрузитьНастройкиИИсториюПоиска()
	
	ИсторияПоиска = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ПолнотекстовыйПоискСтрокиПолнотекстовогоПоиска", "", Новый Массив);
	Элементы.СтрокаПоиска.СписокВыбора.ЗагрузитьЗначения(ИсторияПоиска);
	
	СохраненныеНастройкиПоиска = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("НастройкиПолнотекстовогоПоиска", "", НастройкиПоиска());
	ИскатьВРазделах = СохраненныеНастройкиПоиска.ИскатьВРазделах;
	ОбластиПоиска   = СохраненныеНастройкиПоиска.ОбластиПоиска;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьСтрокуПоискаВИстории(СтрокаПоиска)
	
	ИсторияПоиска = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ПолнотекстовыйПоискСтрокиПолнотекстовогоПоиска", "", Новый Массив);
	СохраненнаяСтрока = ИсторияПоиска.Найти(СтрокаПоиска);
	Если СохраненнаяСтрока <> Неопределено Тогда
		ИсторияПоиска.Удалить(СохраненнаяСтрока);
	КонецЕсли;
	
	ИсторияПоиска.Вставить(0, СтрокаПоиска);
	КоличествоСтрок = ИсторияПоиска.Количество();
	Если КоличествоСтрок > 20 Тогда
		ИсторияПоиска.Удалить(КоличествоСтрок - 1);
	КонецЕсли;
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ПолнотекстовыйПоискСтрокиПолнотекстовогоПоиска", "", ИсторияПоиска);
	Элементы.СтрокаПоиска.СписокВыбора.ЗагрузитьЗначения(ИсторияПоиска);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СохранитьНастройкиПоиска(ИскатьВРазделах, ОбластиПоиска)
	
	Настройки = НастройкиПоиска();
	Настройки.ИскатьВРазделах = ИскатьВРазделах;
	Настройки.ОбластиПоиска = ОбластиПоиска;
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("НастройкиПолнотекстовогоПоиска", "", Настройки);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция НастройкиПоиска()
	
	Настройки = Новый Структура;
	Настройки.Вставить("ИскатьВРазделах", Ложь);
	Настройки.Вставить("ОбластиПоиска",   Новый СписокЗначений);
	Возврат Настройки;
	
КонецФункции

#КонецОбласти

#КонецОбласти
