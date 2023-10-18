﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает машиночитаемую доверенность в виде набора файлов.
// Если файлы доверенности еще не сформированы, то возвращается пустой набор файлов.
// 
// Параметры:
//  Доверенность - СправочникСсылка.МашиночитаемыеДоверенности
//  ДляНалоговыхОрганов - Булево - если Истина, имя файла будет сформировано 
//    в соответствии с требованиями налоговых органов.
//  
// Возвращаемое значение:
//   Массив из Структура:
//    * ИмяФайла - Строка
//    * ТипФайла - Строка - принимает значения "Доверенность" или "Подпись".
//    * ДвоичныеДанные - ДвоичныеДанные
//    * ОписаниеОшибки - Строка
//
Функция ФайлыДоверенности(Знач Доверенность, Знач ДляНалоговыхОрганов) Экспорт
	
	Доверенности = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Доверенность);
	Возврат ФайлыДоверенностей(Доверенности, ДляНалоговыхОрганов)[Доверенность];
	
КонецФункции

// Возвращает машиночитаемые доверенности в виде набора файлов.
// Если файлы отдельно взятой доверенности еще не сформированы, то по ней возвращается пустой набор файлов.
// 
// Параметры:
//  Доверенности - Массив из СправочникСсылка.МашиночитаемыеДоверенности
//  ДляНалоговыхОрганов - Булево - если Истина, имена файлов будут сформированы 
//    в соответствии с требованиями налоговых органов.
//  
// Возвращаемое значение:
//   Соответствие из КлючИЗначение:
//    * Ключ - СправочникСсылка.МашиночитаемыеДоверенности
//    * Значение - см. ФайлыДоверенности
//
Функция ФайлыДоверенностей(Знач Доверенности, Знач ДляНалоговыхОрганов) Экспорт
	
	Возврат Справочники.МашиночитаемыеДоверенности.ФайлыДоверенностей(Доверенности, ДляНалоговыхОрганов);
	
КонецФункции

// Отбор для доверенностей по сертификату.
// 
// Параметры:
//  Сертификат - СертификатКриптографии
//             - ДвоичныеДанные
//             - Строка - адрес двоичных данных сертификата во временном хранилище.
//             - СправочникСсылка.СертификатыКлючейЭлектроннойПодписиИШифрования.
//  Префикс    - см. ДоверенностиСОтбором.
//
// Возвращаемое значение:
//  Структура
//
Функция ОтборДляДоверенностейПоСертификату(Знач Сертификат, Префикс) Экспорт
	
	Если ТипЗнч(Сертификат) = Тип("СправочникСсылка.СертификатыКлючейЭлектроннойПодписиИШифрования") Тогда
		Сертификат = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Сертификат, "ДанныеСертификата").Получить();
	ИначеЕсли ТипЗнч(Сертификат) = Тип("Строка") И ЭтоАдресВременногоХранилища(Сертификат) Тогда
		Сертификат = ПолучитьИзВременногоХранилища(Сертификат);
	КонецЕсли;
	
	Если ТипЗнч(Сертификат) = Тип("ДвоичныеДанные") Тогда
		Сертификат = Новый СертификатКриптографии(Сертификат);
	КонецЕсли;
	
	СвойстваСубъекта = ЭлектроннаяПодпись.СвойстваСубъектаСертификата(Сертификат);
	Отбор = Новый Структура;

	Если ЗначениеЗаполнено(СвойстваСубъекта.ОГРНИП) Тогда
		Отбор.Вставить(Префикс + "ОГРН", СвойстваСубъекта.ОГРНИП);
		Отбор.Вставить(Префикс + "ИННФЛ", СвойстваСубъекта.ИНН);
	ИначеЕсли ЗначениеЗаполнено(СвойстваСубъекта.Организация) Тогда
		Отбор.Вставить(Префикс + "ОГРН", СвойстваСубъекта.ОГРН);
		Отбор.Вставить(Префикс + "ИННФЛ", СвойстваСубъекта.ИНН);
		Отбор.Вставить(Префикс + "ИНН", СвойстваСубъекта.ИННЮЛ);
		Отбор.Вставить(Префикс + "СНИЛС", СвойстваСубъекта.СНИЛС);
	Иначе
		Отбор.Вставить(Префикс + "ИННФЛ", СвойстваСубъекта.ИНН);
		Отбор.Вставить(Префикс + "СНИЛС", СвойстваСубъекта.СНИЛС);
	КонецЕсли;
	
	Возврат Отбор;
	
КонецФункции

// Доверенности с отбором. Если в отборе не передана доверенность, то отбор производится только по не помеченным на удаление.
// 
// Параметры:
//  Отбор - Структура - содержит имя и значение поля, по которому надо отобрать доверенности:
//      "ПредставительИНН", "ПредставительОГРН", "ПредставительСНИЛС", "ПредставительОрганизация", "ПредставительФизическоеЛицо",
//      "ДоверительИНН", "ДоверительКПП", "ДоверительОрганизация", "ДоверительФизическоеЛицо" и т.п. 
//       По умолчанию будут подобраны доверенности с признаками Верна, Подписана и статусом Действует.
//       Если значение отбора Неопределено, отбор по полю не производится.
//  ВыбранныеПоля - Массив из Строка, Строка - массив строк или строка через запятую: поля, которые нужно возвращать.
//  НаДату - Дата - по умолчанию - текущая дата сеанса: дата, на которую определяется действительность доверенности.
//       Если передана пустая дата, отбор по периоду действия не будет использоваться.
//
// Возвращаемое значение:
//  ТаблицаЗначений
//
Функция ДоверенностиСОтбором(Отбор, Знач ВыбранныеПоля, Знач НаДату = Неопределено) Экспорт
	
	СтруктураОтборов = Новый Структура;
	СтруктураОтборов.Вставить("Верна", Истина);
	СтруктураОтборов.Вставить("Подписана", Истина);
	СтруктураОтборов.Вставить("Статус", Перечисления.СтатусыМЧД.Действует);
	
	ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(СтруктураОтборов, Отбор, Истина);
	
	Если ВыбранныеПоля = Неопределено Тогда
		ВыбранныеПоля = Новый Массив;
		ВыбранныеПоля.Добавить("МашиночитаемаяДоверенность");
		ВыбранныеПоля.Добавить("ПредставительОрганизация");
		ВыбранныеПоля.Добавить("ПредставительФизическоеЛицо");
		ВыбранныеПоля.Добавить("ДоверительОрганизация");
		ВыбранныеПоля.Добавить("ДоверительФизическоеЛицо");
		ВыбранныеПоля.Добавить("НомерДоверенности");
		ВыбранныеПоля.Добавить("Наименование");
		ВыбранныеПоля.Добавить("ДатаВыдачи");
	ИначеЕсли ТипЗнч(ВыбранныеПоля) = Тип("Строка") Тогда
		ВыбранныеПоля = СтрРазделить(ВыбранныеПоля, ", ", Ложь);
	КонецЕсли;
	
	Если НаДату = Неопределено Тогда
		НаДату = ТекущаяДатаСеанса();
	КонецЕсли;
	
	КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
	
	СхемаКомпоновкиДанных = Новый СхемаКомпоновкиДанных;
	ИсточникДанных = СхемаКомпоновкиДанных.ИсточникиДанных.Добавить();
	ИсточникДанных.Имя = "ИсточникДанных1";
	ИсточникДанных.ТипИсточникаДанных = "Local";
	
	НаборДанных = СхемаКомпоновкиДанных.НаборыДанных.Добавить(Тип("НаборДанныхЗапросСхемыКомпоновкиДанных"));
	НаборДанных.Имя = "НаборДанных1";
	НаборДанных.ИсточникДанных = ИсточникДанных.Имя;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	МашиночитаемыеДоверенности.Ссылка КАК МашиночитаемаяДоверенность,
	|	МашиночитаемыеДоверенностиПредставители.ИНН КАК ПредставительИНН,
	|	МашиночитаемыеДоверенностиПредставители.ИННФЛ КАК ПредставительИННФЛ,
	|	МашиночитаемыеДоверенностиПредставители.ОГРН КАК ПредставительОГРН,
	|	МашиночитаемыеДоверенностиПредставители.СНИЛС КАК ПредставительСНИЛС,
	|	МашиночитаемыеДоверенностиПредставители.КПП КАК ПредставительКПП,
	|	МашиночитаемыеДоверенностиПредставители.Организация КАК ПредставительОрганизация,
	|	МашиночитаемыеДоверенностиПредставители.ФизическоеЛицо КАК ПредставительФизическоеЛицо,
	|	МашиночитаемыеДоверенностиДоверители.ИНН КАК ДоверительИНН,
	|	МашиночитаемыеДоверенностиДоверители.ИННФЛ КАК ДоверительИННФЛ,
	|	МашиночитаемыеДоверенностиДоверители.ОГРН КАК ДоверительОГРН,
	|	МашиночитаемыеДоверенностиДоверители.СНИЛС КАК ДоверительСНИЛС,
	|	МашиночитаемыеДоверенностиДоверители.КПП КАК ДоверительКПП,
	|	МашиночитаемыеДоверенностиДоверители.Организация КАК ДоверительОрганизация,
	|	МашиночитаемыеДоверенностиДоверители.ФизическоеЛицо КАК ДоверительФизическоеЛицо,
	|	МашиночитаемыеДоверенности.НомерДоверенности КАК НомерДоверенности,
	|	МашиночитаемыеДоверенности.Верна КАК Верна,
	|	МашиночитаемыеДоверенности.Статус КАК Статус,
	|	МашиночитаемыеДоверенности.ДатаВыдачи КАК ДатаВыдачи,
	|	МашиночитаемыеДоверенности.Наименование КАК Наименование,
	|	МашиночитаемыеДоверенностиСтатусы.ТехническийСтатус КАК ТехническийСтатус,
	|	МашиночитаемыеДоверенностиСтатусы.Подписана КАК Подписана,
	|	МашиночитаемыеДоверенности.ДатаОкончания КАК ДатаОкончания,
	|	МашиночитаемыеДоверенности.ДатаОтмены КАК ДатаОтмены,
	|	МашиночитаемыеДоверенности.ПометкаУдаления КАК ПометкаУдаления
	|ИЗ
	|	РегистрСведений.МашиночитаемыеДоверенностиПредставителиИДоверители КАК МашиночитаемыеДоверенностиПредставители
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.МашиночитаемыеДоверенностиПредставителиИДоверители КАК МашиночитаемыеДоверенностиДоверители
	|		ПО (МашиночитаемыеДоверенностиПредставители.ТипУчастника = ЗНАЧЕНИЕ(Перечисление.ТипыУчастниковМЧД.Представитель))
	|			И (МашиночитаемыеДоверенностиДоверители.ТипУчастника = ЗНАЧЕНИЕ(Перечисление.ТипыУчастниковМЧД.Доверитель))
	|			И (МашиночитаемыеДоверенностиДоверители.МашиночитаемаяДоверенность = МашиночитаемыеДоверенностиПредставители.МашиночитаемаяДоверенность)
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.МашиночитаемыеДоверенности КАК МашиночитаемыеДоверенности
	|		ПО МашиночитаемыеДоверенностиПредставители.МашиночитаемаяДоверенность = МашиночитаемыеДоверенности.Ссылка
	|		{ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.МашиночитаемыеДоверенностиСтатусы КАК МашиночитаемыеДоверенностиСтатусы
	|		ПО (МашиночитаемыеДоверенности.Ссылка = МашиночитаемыеДоверенностиСтатусы.МашиночитаемаяДоверенность)}
	|";
	
	Условия = Новый Массив;
	
	Если НаДату <> Дата(1,1,1) Тогда
		
		Условия.Добавить("НАЧАЛОПЕРИОДА(МашиночитаемыеДоверенности.ДатаВыдачи, ДЕНЬ) <= &НаДату
			|	И (КОНЕЦПЕРИОДА(МашиночитаемыеДоверенности.ДатаОкончания, ДЕНЬ) >= &НаДату
			|	И МашиночитаемыеДоверенности.ДатаОтмены = ДАТАВРЕМЯ(1,1,1)
			|	ИЛИ МашиночитаемыеДоверенности.ДатаОтмены >= &НаДату)");
		
		ПараметрДата = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Добавить();
		ПараметрДанных               = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Добавить();
		ПараметрДата.Использование = Истина;
		ПараметрДата.Значение      = НаДату;
		ПараметрДата.Параметр      = Новый ПараметрКомпоновкиДанных("НаДату");

	КонецЕсли;
	
	Если Не СтруктураОтборов.Свойство("МашиночитаемаяДоверенность") Тогда
		Условия.Добавить("НЕ МашиночитаемыеДоверенности.ПометкаУдаления");
	КонецЕсли;
	
	Если Условия.Количество() > 0 Тогда
		ТекстЗапроса = ТекстЗапроса + "
		|ГДЕ " + СтрСоединить(Условия, Символы.ПС + "И ");
	КонецЕсли;
	
	СхемаКомпоновкиДанных.НаборыДанных[0].Запрос = ТекстЗапроса;
	
	Структура = КомпоновщикНастроек.Настройки.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
	
	Для Каждого Поле Из ВыбранныеПоля Цикл
		ВыбранноеПоле = Структура.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
		ВыбранноеПоле.Поле = Новый ПолеКомпоновкиДанных(Поле);
	КонецЦикла;
	
	Для Каждого ЭлементОтбора Из СтруктураОтборов Цикл
		
		Если ЭлементОтбора.Значение = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
				КомпоновщикНастроек.Настройки.Отбор, ЭлементОтбора.Ключ, ЭлементОтбора.Значение);
		
	КонецЦикла;
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	
	Порядок = КомпоновщикНастроек.Настройки.Порядок;
	ЭлементПорядка = Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
	ЭлементПорядка.Поле = Новый ПолеКомпоновкиДанных("ДатаВыдачи");
	ЭлементПорядка.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Убыв;
	ЭлементПорядка.Использование = Истина;
	
	МакетКомпоновкиДанных = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, КомпоновщикНастроек.Настройки, , ,
		Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновкиДанных);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	ПроцессорВывода.УстановитьОбъект(Новый ТаблицаЗначений);

	Результат = ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);

	Возврат Результат;
	
КонецФункции

// Добавляет подпись к доверенности, устанавливает признак, что подписана, если есть все подписи доверенности. 
//
// Параметры:
//  ФайлДоверенности - СправочникСсылка.МашиночитаемыеДоверенностиПрисоединенныеФайлы
//  Подпись - см. ЭлектроннаяПодписьКлиентСервер.НовыеСвойстваПодписи
//          - ДвоичныеДанные - данные подписи в формате DER
//          - Строка - адрес двоичных данных подписи во временном хранилище.
// Возвращаемое значение:
//  Булево - Истина, если удалось добавить подпись
//  Строка - текст ошибки, если подпись не соответствует доверенности
//
Функция ДобавитьПодписьКФайлуДоверенности(ФайлДоверенности, Знач Подпись) Экспорт
	
	Если ТипЗнч(Подпись) = Тип("Строка") И ЭтоАдресВременногоХранилища(Подпись) Тогда
		Подпись = ПолучитьИзВременногоХранилища(Подпись);
	КонецЕсли;
	
	Если ТипЗнч(Подпись) = Тип("ДвоичныеДанные") Тогда
		СвойстваПодписи = ЭлектроннаяПодпись.СвойстваПодписи(Подпись, Истина);
		Если СвойстваПодписи.Успех = Ложь Тогда
			ВызватьИсключение Подпись.ТекстОшибки;
		КонецЕсли;
		НовыеСвойстваПодписи = ЭлектроннаяПодписьКлиентСервер.НовыеСвойстваПодписи();
		ЗаполнитьЗначенияСвойств(НовыеСвойстваПодписи, СвойстваПодписи);
		НовыеСвойстваПодписи.Подпись = Подпись;
		СвойстваПодписи = НовыеСвойстваПодписи;
	Иначе
		СвойстваПодписи = Подпись;
	КонецЕсли;
	
	Доверенность = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ФайлДоверенности, "ВладелецФайла");
	Результат = МашиночитаемыеДоверенностиФНССлужебный.ПроверитьСертификатДоверителя(Доверенность, ФайлДоверенности, СвойстваПодписи.Сертификат);
	
	Если ТипЗнч(Результат) = Тип("Строка") Тогда
		Возврат Результат;
	КонецЕсли;
	
	ЭлектроннаяПодпись.ДобавитьПодпись(ФайлДоверенности, СвойстваПодписи);
	
	Если Результат = Истина Тогда
		МашиночитаемыеДоверенностиФНССлужебный.РассчитатьТехническийСтатус(Доверенность, Истина);
	КонецЕсли;
	
	Возврат Истина;

КонецФункции

// Реквизиты представителя организации.
// 
// Параметры:
//  ФизическоеЛицо - ОпределяемыйТип.ФизическоеЛицо
//  ЭтоИндивидуальныйПредприниматель - Булево - это индивидуальный предприниматель
//  Должность - Строка - должность представителя организации
// 
// Возвращаемое значение:
//  Структура - см. МашиночитаемыеДоверенностиФНСПереопределяемый.ПриЗаполненииРеквизитовФизическогоЛица.Реквизиты
//
Функция РеквизитыПредставителяОрганизации(ФизическоеЛицо, ЭтоИндивидуальныйПредприниматель = Ложь, Должность = Неопределено) Экспорт
	
	ТипЭлемента = "ФизическоеЛицо";
	ВидУчастника = ?(ЭтоИндивидуальныйПредприниматель, "ИндивидуальныйПредприниматель", "ДолжностноеЛицо");
	Реквизиты = МашиночитаемыеДоверенностиФНССлужебныйКлиентСервер.РеквизитыУчастника(ТипЭлемента, ФизическоеЛицо, ВидУчастника);
	Если Не ЭтоИндивидуальныйПредприниматель И ЗначениеЗаполнено(Должность) Тогда
		Реквизиты.ДолжностьЛицаДоверителя = Должность;
	КонецЕсли;
	
	Возврат Реквизиты;
	
КонецФункции

// Возвращает результат проверки доверенности.
// 
// Параметры:
//  Доверенность - СправочникСсылка.МашиночитаемыеДоверенности
//  ПроверятьВРеестреФНС - Булево, Неопределено - если Неопределено, то в зависимости от признака РегистрироватьВРеестре
//
// Возвращаемое значение:
//  Структура:
//   * Верна - Булево - подписи доверенности верны и соответствуют доверителям.
//   * ТребуетсяПроверка - Булево - если есть подписи, требующие проверки или не удалось получить статус в реестре ФНС.
//   * Статус - ПеречислениеСсылка.СтатусыМЧД
//   * ЕстьВРеестреФНС - Булево - доверенность удалось проверить в реестре ФНС
//   * ТекстОшибки - Строка
//   * ЕстьВсеПодписи - Булево - есть все подписи доверителей.
//   * РезультатыПроверкиПодписей - Массив из Структура:
//     ** Верна - Булево
//     ** КомуВыданСертификат - Строка
//     ** ДатаПодписи - Дата
//     ** ИдентификаторПодписи - УникальныйИдентификатор
//     ** ТребуетсяПроверка - Булево
//     ** Соответствует -  Булево - подпись соответствует доверителю.
//     ** ТекстОшибки - Строка
//     ** ТекстОшибкиСоответствия - Строка
//     ** РезультатПроверки - Неопределено - если подпись не требовалось проверять или не удалось ее проверить.
//                         - см. ЭлектроннаяПодписьКлиентСервер.РезультатПроверкиПодписи
//
Функция РезультатПроверкиДоверенности(Доверенность, ПроверятьВРеестреФНС = Неопределено) Экспорт
	
	Возврат МашиночитаемыеДоверенностиФНССлужебный.РезультатПроверкиДоверенности(Доверенность, ПроверятьВРеестреФНС);
	
КонецФункции

// Проверяет записанную в базу подпись на соответствие подписанту, документу, действие доверенности на дату подписи.
// 
// Параметры:
//  ПодписанныйОбъект - ОпределяемыйТип.ПодписанныйОбъект - ссылка на подписанный объект.
//  ИдентификаторПодписи - УникальныйИдентификатор - см. ЭлектроннаяПодписьКлиентСервер.НовыеСвойстваПодписи.ИдентификаторПодписи
//  СертификатПодписи - СертификатКриптографии
//                    - ДвоичныеДанные
//                    - Строка - адрес двоичных данных во временном хранилище.
//  НаДату - Дата - дата подписи, если не заполнена, проверка будет выполнена на дату сеанса.
// 
// Возвращаемое значение:
//  Массив из Структура:
//   * МашиночитаемаяДоверенность - СправочникСсылка.МашиночитаемыеДоверенности
//   * ТребуетсяПроверка - Булево - если Истина, не удалось проверить доверенность.
//   * ДатаПроверки - Дата
//   * Верна - Булево
//   * ПодписантСоответствуетПредставителю - Булево
//   * СовместныеПолномочия - Булево
//   * СовместныеПолномочияВерны - Булево
//   * ПротоколПроверки - Соответствие из КлючИЗначение:
//      ** Ключ - Строка - идентификатор проверки
//      ** Значение - см. РезультатПроверкиДляПротокола
//
Функция РезультатПроверкиПодписиПоМЧД(ПодписанныйОбъект, ИдентификаторПодписи, СертификатПодписи, НаДату) Экспорт
	
	Результат = Новый Массив;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЭлектронныеПодписиМЧД.МашиночитаемаяДоверенность КАК Ссылка,
	|	ПРЕДСТАВЛЕНИЕ(ЭлектронныеПодписиМЧД.МашиночитаемаяДоверенность) КАК Представление,
	|	МашиночитаемыеДоверенности.ФайлДоверенности КАК ФайлДоверенности,
	|	МашиночитаемыеДоверенности.Статус КАК Статус,
	|	МашиночитаемыеДоверенности.Верна КАК Верна,
	|	МашиночитаемыеДоверенности.НомерДоверенности КАК НомерДоверенности,
	|	МашиночитаемыеДоверенности.СтатусВернаУстановленВручную КАК СтатусВернаУстановленВручную,
	|	МашиночитаемыеДоверенности.УстановившийСтатусВерна КАК УстановившийСтатусВерна,
	|	МашиночитаемыеДоверенности.ДатаПроверки КАК ДатаПроверки,
	|	МашиночитаемыеДоверенности.ДатаОтмены КАК ДатаОтмены,
	|	МашиночитаемыеДоверенности.ТекстПолномочий КАК ТекстПолномочий,
	|	МашиночитаемыеДоверенности.Полномочия.(
	|		Ссылка КАК Ссылка,
	|		НомерСтроки КАК НомерСтроки,
	|		Код КАК Код,
	|		ИдентификаторПолномочия КАК ИдентификаторПолномочия,
	|		Мнемокод КАК Мнемокод,
	|		Наименование КАК Наименование) КАК Полномочия,
	|	МашиночитаемыеДоверенности.Ограничения.(
	|		Ссылка КАК Ссылка,
	|		НомерСтроки КАК НомерСтроки,
	|		ИдентификаторПолномочия КАК ИдентификаторПолномочия,
	|		Код КАК Код,
	|		Наименование КАК Наименование,
	|		НаименованиеЗначения КАК НаименованиеЗначения,
	|		КодЗначения КАК КодЗначения,
	|		ТекстовоеЗначение КАК ТекстовоеЗначение) КАК Ограничения,
	|	МашиночитаемыеДоверенности.ПолномочияВТекстовомВиде КАК ПолномочияВТекстовомВиде,
	|	ЭлектронныеПодписиМЧД.ПодписанныйОбъект КАК ПодписанныйОбъект,
	|	ЭлектронныеПодписиМЧД.ИдентификаторПодписи КАК ИдентификаторПодписи,
	|	МашиночитаемыеДоверенности.ПометкаУдаления,
	|	МашиночитаемыеДоверенности.РегистрироватьВРеестре,
	|	ЭлектронныеПодписиМЧД.ПротоколПроверки,
	|	МашиночитаемыеДоверенности.СовместныеПолномочия
	|ИЗ
	|	РегистрСведений.ЭлектронныеПодписиМЧД КАК ЭлектронныеПодписиМЧД
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.МашиночитаемыеДоверенности КАК МашиночитаемыеДоверенности
	|		ПО ЭлектронныеПодписиМЧД.МашиночитаемаяДоверенность = МашиночитаемыеДоверенности.Ссылка
	|ГДЕ
	|	ЭлектронныеПодписиМЧД.ПодписанныйОбъект = &ПодписанныйОбъект
	|	И ЭлектронныеПодписиМЧД.ИдентификаторПодписи = &ИдентификаторПодписи";
	
	Запрос.УстановитьПараметр("ПодписанныйОбъект", ПодписанныйОбъект);
	Запрос.УстановитьПараметр("ИдентификаторПодписи", ИдентификаторПодписи);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		РезультатПроверкиПодписиПоМЧД = МашиночитаемыеДоверенностиФНССлужебный.РезультатПроверкиПодписиПоДаннымМЧД(
			Выборка, СертификатПодписи, НаДату);
		Результат.Добавить(РезультатПроверкиПодписиПоМЧД);
		
	КонецЦикла;
	
	Возврат Результат;

КонецФункции

// Результат проверки для записи в протокол.
// 
// Возвращаемое значение:
//  Структура:
//   * ЗаголовокПроверки - Строка - например, "Проверка документа".
///   * ТекстПроверки - Строка - например, "Организация не соответствует доверителю".
//   * Верна - Неопределено, Булево - если Неопределено - значит, требуется проверка.
//   * ДатаПроверки - Дата
//   * ДополнительныеДанные - Произвольный - дополнительные сведения о проверке, которые сохраняются в информационной базе.
//
Функция РезультатПроверкиДляПротокола() Экспорт
	
	Структура = Новый Структура;
	Структура.Вставить("Верна", Неопределено);
	Структура.Вставить("ЗаголовокПроверки", "");
	Структура.Вставить("ТекстПроверки", "");
	Структура.Вставить("ДатаПроверки");
	Структура.Вставить("РучнаяПроверка", Ложь);
	Структура.Вставить("ДополнительныеДанные");
	Возврат Структура;

КонецФункции

#КонецОбласти
