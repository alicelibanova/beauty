﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Результат проверки подписи по МЧД.
// 
// Параметры:
//  Доверенность - СправочникСсылка.МашиночитаемыеДоверенности
// 
// Возвращаемое значение:
//  Структура:
//   * МашиночитаемаяДоверенность - СправочникСсылка.МашиночитаемыеДоверенности
//   * Представление - Строка - представление доверенности для отображения пользователям, т.к. может не быть прав на чтение.
//   * ТребуетсяПроверка - Булево 
//   * ДатаПроверки - Дата
//   * Верна - Булево
//   * ПодписантСоответствуетПредставителю - Булево
//   * СовместныеПолномочия - Булево
//   * СовместныеПолномочияВерны - Булево
//   * СтатусВернаУстановленВручную - Булево
//   * УстановившийСтатусВерна - СправочникСсылка.Пользователи
//   * ПротоколПроверки - Соответствие из КлючИЗначение:
//      ** Ключ - Строка - идентификатор проверки
//      ** Значение - см. МашиночитаемыеДоверенностиФНС.РезультатПроверкиДляПротокола
//
Функция РезультатПроверкиПодписиПоМЧД(Доверенность) Экспорт
	
	Структура = Новый Структура;
	Структура.Вставить("Представление");
	Структура.Вставить("МашиночитаемаяДоверенность", Доверенность);
	Структура.Вставить("ТребуетсяПроверка", Истина);
	Структура.Вставить("ДатаПроверки");
	Структура.Вставить("Верна");
	Структура.Вставить("ПодписантСоответствуетПредставителю");
	Структура.Вставить("СовместныеПолномочия");
	Структура.Вставить("СовместныеПолномочияВерны");
	Структура.Вставить("ПротоколПроверки");
	Структура.Вставить("СтатусВернаУстановленВручную", Ложь);
	Структура.Вставить("УстановившийСтатусВерна");
	
	Возврат Структура;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПерсональныеДанные() Экспорт
	
	ПерсональныеДанные = Новый Массив;
	ПерсональныеДанные.Добавить("ДатаРождения");
	ПерсональныеДанные.Добавить("МестоРождения");
	ПерсональныеДанные.Добавить("АдресРегистрации");
	ПерсональныеДанные.Добавить("ДокументНомер");
	ПерсональныеДанные.Добавить("ДокументКемВыдан");
	ПерсональныеДанные.Добавить("ДокументДатаВыдачи");
	ПерсональныеДанные.Добавить("ДокументКодПодразделения");
	ПерсональныеДанные.Добавить("ДокументСрокДействия");
	ПерсональныеДанные.Добавить("СтраховойНомерПФР");
	ПерсональныеДанные.Добавить("НомерЗаписиЕдиногоРегистраНаселения");
	
	Возврат ПерсональныеДанные;
	
КонецФункции

Функция ЭтоПолномочиеФНС(КодПолномочия) Экспорт
	Возврат СтрНачинаетсяС(КодПолномочия, "1_FNS")
			Или СтрНачинаетсяС(КодПолномочия, "FNS_");
КонецФункции

Функция РасчетныйСтатусДокумента(ТехническийСтатус, Верна) Экспорт
	
	Если ТехническийСтатус = ПредопределенноеЗначение("Перечисление.ТехническиеСтатусыМЧД.Зарегистрирована")
		Или ТехническийСтатус = ПредопределенноеЗначение("Перечисление.ТехническиеСтатусыМЧД.РегистрацияОтмены")
		Или ТехническийСтатус = ПредопределенноеЗначение("Перечисление.ТехническиеСтатусыМЧД.Активна") Тогда
		Если Верна Тогда
			РасчетныйСтатусДокумента = ПредопределенноеЗначение("Перечисление.СтатусыМЧД.Действует");
		Иначе
			РасчетныйСтатусДокумента = ПредопределенноеЗначение("Перечисление.СтатусыМЧД.НеДействует");
		КонецЕсли;
	ИначеЕсли ТехническийСтатус = ПредопределенноеЗначение("Перечисление.ТехническиеСтатусыМЧД.Создание")
		Или ТехническийСтатус = ПредопределенноеЗначение("Перечисление.ТехническиеСтатусыМЧД.Подписание")
		Или ТехническийСтатус = ПредопределенноеЗначение("Перечисление.ТехническиеСтатусыМЧД.Подписана")
		Или ТехническийСтатус = ПредопределенноеЗначение("Перечисление.ТехническиеСтатусыМЧД.Регистрация") Тогда
		РасчетныйСтатусДокумента = ПредопределенноеЗначение("Перечисление.СтатусыМЧД.Черновик");
	Иначе
		РасчетныйСтатусДокумента = ПредопределенноеЗначение("Перечисление.СтатусыМЧД.НеДействует");
	КонецЕсли;
	
	Возврат РасчетныйСтатусДокумента;
	
КонецФункции

Функция ВнешниеСтатусы() Экспорт
	
	ВнешниеСтатусы = Новый Соответствие;
	ВнешниеСтатусы.Вставить(ПредопределенноеЗначение("Перечисление.ТехническиеСтатусыМЧД.Регистрация"), Истина);
	ВнешниеСтатусы.Вставить(ПредопределенноеЗначение("Перечисление.ТехническиеСтатусыМЧД.Зарегистрирована"), Истина);
	ВнешниеСтатусы.Вставить(ПредопределенноеЗначение("Перечисление.ТехническиеСтатусыМЧД.РегистрацияОтмены"), Истина);
	ВнешниеСтатусы.Вставить(ПредопределенноеЗначение("Перечисление.ТехническиеСтатусыМЧД.Отменена"), Истина);
	ВнешниеСтатусы.Вставить(ПредопределенноеЗначение("Перечисление.ТехническиеСтатусыМЧД.ОшибкаРегистрации"), Истина);
	ВнешниеСтатусы.Вставить(ПредопределенноеЗначение("Перечисление.ТехническиеСтатусыМЧД.Просрочена"), Истина);
	ВнешниеСтатусы.Вставить(ПредопределенноеЗначение("Перечисление.ТехническиеСтатусыМЧД.ДатаНачалаДействияНеНаступила"), Истина);

	Возврат ВнешниеСтатусы;
	
КонецФункции

// Реквизиты организации.
// 
// Параметры:
//  ДляЗаполнения - Булево - если Истина, полный список реквизитов
//  ВидОрганизации - Неопределено, Строка - "ИндивидуальныйПредприниматель", "ИностраннаяОрганизация", "Филиал"
// 
// Возвращаемое значение:
//  СписокЗначений
//	
Функция РеквизитыОрганизацииСписок(ДляЗаполнения = Истина, ВидОрганизации = Неопределено) Экспорт
	
	Реквизиты = Новый СписокЗначений;
	Реквизиты.Добавить("ЭтоИндивидуальныйПредприниматель", НСтр("ru = 'Индивидуальный предприниматель';
																|en = 'Individual entrepreneur'"), Истина);
	Реквизиты.Добавить("ЭтоФизическоеЛицо",                НСтр("ru = 'Физическое лицо';
																|en = 'Individual'"), Истина);
	Реквизиты.Добавить("ЭтоКонтрагент",                    НСтр("ru = 'Контрагент';
																|en = 'Counterparty'"), Истина);
	Реквизиты.Добавить("ЭтоИностраннаяОрганизация",        НСтр("ru = 'Иностранная организация';
																|en = 'Foreign company'"), Истина); 
	Реквизиты.Добавить("ЭтоФилиал",                        НСтр("ru = 'Филиал';
																|en = 'Branch office'"), Истина); 
	Реквизиты.Добавить("НаименованиеПолное",               НСтр("ru = 'Наименование (полное)';
																|en = 'Full name'"));
	Реквизиты.Добавить("НаименованиеСокращенное",          НСтр("ru = 'Наименование (сокращенное)';
																|en = 'Short name'"), Истина);
	Реквизиты.Добавить("ИНН",                              НСтр("ru = 'ИНН';
																|en = 'TIN'"));
	
	Реквизиты.Добавить("ЭлектроннаяПочта",                 НСтр("ru = 'Электронная почта';
																|en = 'Email'"), Истина);
	Реквизиты.Добавить("ЭлектроннаяПочтаЗначение",         НСтр("ru = 'Электронная почта';
																|en = 'Email'"), Истина);
	Реквизиты.Добавить("Телефон",                          НСтр("ru = 'Телефон';
																|en = 'Phone'"), Истина);
	Реквизиты.Добавить("ТелефонЗначение",                  НСтр("ru = 'Телефон';
																|en = 'Phone'"), Истина);
	
	Если ДляЗаполнения Или ВидОрганизации <> "ИндивидуальныйПредприниматель" Тогда
		Реквизиты.Добавить("КПП", НСтр("ru = 'КПП';
										|en = 'KPP'"));
	КонецЕсли;
	
	Если ДляЗаполнения Или ВидОрганизации <> "ИностраннаяОрганизация" Тогда
		Реквизиты.Добавить("ОГРН", НСтр("ru = 'ОГРН';
										|en = 'OGRN'"));
	КонецЕсли;
	
	Если ДляЗаполнения Или ВидОрганизации = "ИностраннаяОрганизация" Тогда
		Реквизиты.Добавить("НомерЗаписиОбАккредитации",               НСтр("ru = 'Номер записи об аккредитации';
																			|en = 'Accreditation record number'"));
		Реквизиты.Добавить("СтранаРегистрации",                       НСтр("ru = 'Страна регистрации (инкорпорации)';
																			|en = 'Country of registration (incorporation)'"));
		Реквизиты.Добавить("СтранаРегистрацииКод",                    НСтр("ru = 'Код страны регистрации (инкорпорации)';
																			|en = 'Code of country of registration (incorporation)'"));
		Реквизиты.Добавить("РегистрационныйНомерВСтранеРегистрации",  НСтр("ru = 'Регистрационный номер в стране регистрации (инкорпорации)';
																			|en = 'Registration number in country of registration (incorporation)'"));
		Реквизиты.Добавить("НаименованиеРегистрирующегоОргана",       НСтр("ru = 'Наименование регистрирующего органа';
																			|en = 'Registering authority name'"));
		Реквизиты.Добавить("КодНалогоплательщикаВСтранеРегистрации",  НСтр("ru = 'Код налогоплательщика в стране регистрации (инкорпорации) или аналог';
																			|en = 'Taxpayer identification number in country of registration (incorporation) or its equivalent'"));
		Реквизиты.Добавить("ФактическийАдрес",                        НСтр("ru = 'Фактический адрес местонахождения';
																			|en = 'Business address'"));
		Реквизиты.Добавить("ФактическийАдресЗначение",                НСтр("ru = 'Фактический адрес местонахождения';
																			|en = 'Business address'"), Истина);
		Реквизиты.Добавить("ЮридическийАдресВСтранеРегистрации",      НСтр("ru = 'Адрес юридического лица на территории государства, в котором оно Зарегистрирована';
																			|en = 'Адрес юридического лица на территории государства, в котором оно Зарегистрирована'"));
		Реквизиты.Добавить("ЮридическийАдресВСтранеРегистрацииЗначение", НСтр("ru = 'Адрес юридического лица на территории государства';
																				|en = 'Legal entity address'"), Истина);
	КонецЕсли;
	
	Если ДляЗаполнения Или ВидОрганизации = "РоссийскаяОрганизация" Или ВидОрганизации = "Филиал" Тогда
		Реквизиты.Добавить("НаименованиеУчредительногоДокумента", НСтр("ru = 'Наименование учредительного документа';
																		|en = 'Constituent document name'"), Истина);
		Реквизиты.Добавить("ЮридическийАдрес",         НСтр("ru = 'Адрес регистрации';
															|en = 'Registration address'"));
		Реквизиты.Добавить("ЮридическийАдресЗначение", НСтр("ru = 'Адрес регистрации';
															|en = 'Registration address'"), Истина);
	КонецЕсли;
	
	Если ДляЗаполнения Или ВидОрганизации = "Филиал" Тогда
		Реквизиты.Добавить("РегистрационныйНомерФилиала", НСтр("ru = 'Регистрационный номер филиала';
																|en = 'Registration number of branch office'"), Истина);
	КонецЕсли;
	
	Если ДляЗаполнения И ВидОрганизации = "ИндивидуальныйПредприниматель" Тогда
		Реквизиты.НайтиПоЗначению("КПП").Пометка = Истина;
	КонецЕсли;
	
	Если ДляЗаполнения Тогда
		Реквизиты.Добавить("ЛицоБезДоверенности",          НСтр("ru = 'Представитель без доверенности';
																|en = 'Representative without letter of authority'"));
		Реквизиты.Добавить("РеквизитыЛицаБезДоверенности", НСтр("ru = 'Реквизиты представителя без доверенности';
																|en = 'Details of representative acting without letter of authority'"));
	КонецЕсли;
	
	Если ДляЗаполнения И ВидОрганизации = "ИностраннаяОрганизация" Тогда
		
		Реквизиты.НайтиПоЗначению("ОГРН").Пометка = Истина;
		Реквизиты.НайтиПоЗначению("ЮридическийАдрес").Пометка = Истина;
		Реквизиты.НайтиПоЗначению("НаименованиеУчредительногоДокумента").Пометка = Истина;
		
	ИначеЕсли ДляЗаполнения Тогда
		
		Реквизиты.НайтиПоЗначению("НомерЗаписиОбАккредитации").Пометка = Истина;
		Реквизиты.НайтиПоЗначению("СтранаРегистрации").Пометка = Истина;
		Реквизиты.НайтиПоЗначению("СтранаРегистрацииКод").Пометка = Истина;
		Реквизиты.НайтиПоЗначению("РегистрационныйНомерВСтранеРегистрации").Пометка = Истина;
		Реквизиты.НайтиПоЗначению("НаименованиеРегистрирующегоОргана").Пометка = Истина;
		Реквизиты.НайтиПоЗначению("КодНалогоплательщикаВСтранеРегистрации").Пометка = Истина;
		Реквизиты.НайтиПоЗначению("ФактическийАдрес").Пометка = Истина;
		Реквизиты.НайтиПоЗначению("ЮридическийАдресВСтранеРегистрации").Пометка = Истина;

	КонецЕсли;

	Возврат Реквизиты;
	
КонецФункции

// Реквизиты физического лица.
// 
// Параметры:
//  ДляЗаполнения - Булево - если Истина, полный список реквизитов
//  ВидФизическогоЛица - Неопределено, Строка - "ИндивидуальныйПредприниматель", "ДолжностноеЛицо", "ФизическоеЛицо"
// 
// Возвращаемое значение:
//  СписокЗначений
//
Функция РеквизитыФизическогоЛицаСписок(ДляЗаполнения = Истина, ВидФизическогоЛица = Неопределено) Экспорт
	
	Реквизиты = Новый СписокЗначений;
	Реквизиты.Добавить("ЭтоИндивидуальныйПредприниматель",
		НСтр("ru = 'Это индивидуальный предприниматель';
			|en = 'This is an individual entrepreneur'"), Истина);
	Реквизиты.Добавить("ЭтоФизическоеЛицо",        НСтр("ru = 'Это физическое лицо';
														|en = 'This is an individual'"), Истина);
	Реквизиты.Добавить("ЭтоДолжностноеЛицо",       НСтр("ru = 'Это должностное лицо';
														|en = 'This is an official'"), Истина);
	
	Если ДляЗаполнения Или ВидФизическогоЛица <> "ИндивидуальныйПредприниматель" Тогда
		Реквизиты.Добавить("ДолжностьЛицаДоверителя", НСтр("ru = 'Должность';
															|en = 'Job title'"));
	КонецЕсли;

	Реквизиты.Добавить("Фамилия",                  НСтр("ru = 'Фамилия';
														|en = 'Last name'"));
	Реквизиты.Добавить("Имя",                      НСтр("ru = 'Имя';
														|en = 'First name'"));
	Реквизиты.Добавить("Отчество",                 НСтр("ru = 'Отчество';
														|en = 'Middle name'"), Истина);
	Реквизиты.Добавить("Пол",                      НСтр("ru = 'Пол';
														|en = 'Gender'"));
	Если ДляЗаполнения Или ВидФизическогоЛица <> "ИндивидуальныйПредприниматель" Тогда
		Реквизиты.Добавить("ИННФЛ", НСтр("ru = 'ИНН';
										|en = 'TIN'"));
	КонецЕсли;
	Реквизиты.Добавить("СтраховойНомерПФР",        НСтр("ru = 'СНИЛС';
														|en = 'SNILS'"));
	Реквизиты.Добавить("АдресРегистрации",         НСтр("ru = 'Адрес регистрации';
														|en = 'Registration address'"));
	Реквизиты.Добавить("АдресРегистрацииЗначение", НСтр("ru = 'Адрес регистрации';
														|en = 'Registration address'"), Истина);
	Реквизиты.Добавить("ЭлектроннаяПочта",         НСтр("ru = 'Электронная почта';
														|en = 'Email'"));
	Реквизиты.Добавить("ЭлектроннаяПочтаЗначение", НСтр("ru = 'Электронная почта';
														|en = 'Email'"), Истина);
	Реквизиты.Добавить("Телефон",                  НСтр("ru = 'Телефон';
														|en = 'Phone'"));
	Реквизиты.Добавить("ТелефонЗначение",          НСтр("ru = 'Телефон';
														|en = 'Phone'"), Истина);

	Реквизиты.Добавить("ДатаРождения",             НСтр("ru = 'Дата рождения';
														|en = 'Date of birth'"));
	Реквизиты.Добавить("ДокументВид",              НСтр("ru = 'Вид документа';
														|en = 'Document type'"));
	Реквизиты.Добавить("ДокументНомер",            НСтр("ru = 'Серия и номер';
														|en = 'Series and No.'"));
	Реквизиты.Добавить("ДокументКемВыдан",         НСтр("ru = 'Кем выдан';
														|en = 'Issued by'"));
	Реквизиты.Добавить("ДокументДатаВыдачи",       НСтр("ru = 'Дата выдачи';
														|en = 'Date of issue'"));
	Реквизиты.Добавить("ДокументКодПодразделения", НСтр("ru = 'Код подразделения';
														|en = 'Department code'"));
	Реквизиты.Добавить("ДокументСрокДействия",     НСтр("ru = 'Срок действия';
														|en = 'Date of expiry'"), Истина);
	Реквизиты.Добавить("Гражданство",              НСтр("ru = 'Гражданство';
														|en = 'Citizenship'"), Истина);
	Реквизиты.Добавить("БезГражданства",           НСтр("ru = 'Без гражданства';
														|en = 'Without citizenship'"), Истина);
	Реквизиты.Добавить("МестоРождения",            НСтр("ru = 'Место рождения';
														|en = 'Place of birth'"), Истина);
	
	Реквизиты.Добавить("НомерЗаписиЕдиногоРегистраНаселения",
		НСтр("ru = 'Номер записи единого регистра населения';
			|en = 'Record number in the Unified Register of Population'"), Истина);
	
	Если ДляЗаполнения И ВидФизическогоЛица = "ИндивидуальныйПредприниматель" Тогда
		Реквизиты.НайтиПоЗначению("ИННФЛ").Пометка = Истина;
	КонецЕсли;
	
	Если ВидФизическогоЛица = "ФизическоеЛицо" Тогда
		Реквизиты.НайтиПоЗначению("ДолжностьЛицаДоверителя").Пометка = Истина;
	КонецЕсли;
	
	Если ВидФизическогоЛица = "ДолжностноеЛицо" Тогда
		Реквизиты.НайтиПоЗначению("ДатаРождения").Пометка = Истина;
		Реквизиты.НайтиПоЗначению("ДокументВид").Пометка = Истина;
		Реквизиты.НайтиПоЗначению("ДокументНомер").Пометка = Истина;
		Реквизиты.НайтиПоЗначению("ДокументКемВыдан").Пометка = Истина;
		Реквизиты.НайтиПоЗначению("ДокументДатаВыдачи").Пометка = Истина;
		Реквизиты.НайтиПоЗначению("ДокументКодПодразделения").Пометка = Истина;
	ИначеЕсли ДляЗаполнения Тогда
		Реквизиты.НайтиПоЗначению("ДолжностьЛицаДоверителя").Пометка = Истина;
	КонецЕсли;

	Возврат Реквизиты;
	
КонецФункции

Функция РеквизитыУчастника(ТипЭлемента, ЗначениеЭлемента, ВидУчастника = Неопределено, ДляЗаполнения = Истина) Экспорт
	
	Если ТипЭлемента = "ФизическоеЛицо" Тогда
		Реквизиты = РеквизитыФизическогоЛица(ДляЗаполнения, ВидУчастника);
	Иначе
		Реквизиты = РеквизитыОрганизации(ДляЗаполнения, ВидУчастника);
	КонецЕсли;
	
	Реквизиты.ЭтоФизическоеЛицо = ТипЭлемента = "ФизическоеЛицо";
	Реквизиты.ЭтоИндивидуальныйПредприниматель = ВидУчастника = "ИндивидуальныйПредприниматель";
	
	Если ТипЭлемента = "ФизическоеЛицо" Тогда
		Реквизиты.ЭтоДолжностноеЛицо = ВидУчастника = "ДолжностноеЛицо";
	Иначе
		Реквизиты.ЭтоКонтрагент = ТипЭлемента = "Контрагент";
		Реквизиты.ЭтоИностраннаяОрганизация = ВидУчастника = "ИностраннаяОрганизация";
		Реквизиты.ЭтоФилиал = ВидУчастника = "Филиал";
	КонецЕсли;
	
	Реквизиты.Вставить("Ссылка", ЗначениеЭлемента);
	Реквизиты.Вставить("Тип", ТипЭлемента);
	
	Возврат Реквизиты;
	
КонецФункции

Функция РеквизитыУчастникаДляХранения(Реквизиты) Экспорт
	
	ВидУчастника = ОпределитьВидУчастника(Реквизиты);
	Если Реквизиты.ЭтоФизическоеЛицо Тогда
		РеквизитыУчастника = РеквизитыФизическогоЛица(Ложь, ВидУчастника);
	Иначе
		РеквизитыУчастника = РеквизитыОрганизации(Ложь, ВидУчастника);
	КонецЕсли;
	
	РеквизитыУчастника.Вставить("Тип");
	
	Возврат РеквизитыУчастника;
	
КонецФункции

Функция РеквизитыФизическогоЛица(ДляЗаполнения, ВидУчастника) Экспорт
	
	Реквизиты = РеквизитыФизическогоЛицаСписок(ДляЗаполнения, ВидУчастника);
	Возврат СтруктураРеквизитовИзСписка(Реквизиты);
	
КонецФункции

Функция РеквизитыОрганизации(ДляЗаполнения, ВидУчастника) Экспорт
	
	Реквизиты = РеквизитыОрганизацииСписок(ДляЗаполнения, ВидУчастника);
	Возврат СтруктураРеквизитовИзСписка(Реквизиты);
	
КонецФункции

Функция СтруктураРеквизитовИзСписка(Реквизиты)
	
	МассивРеквизитов = Реквизиты.ВыгрузитьЗначения();
	СтрокаРеквизитов = СтрСоединить(МассивРеквизитов, ",");
	Возврат Новый Структура(СтрокаРеквизитов);
	
КонецФункции

Функция ПредставлениеНеограниченныхПолномочий() Экспорт
	Возврат НСтр("ru = 'Все полномочия';
				|en = 'All powers'");
КонецФункции

Функция ОпределитьВидУчастника(Реквизиты) Экспорт
	
	Если Реквизиты.ЭтоФизическоеЛицо Тогда
		Если Реквизиты.ЭтоДолжностноеЛицо Тогда
			Возврат "ДолжностноеЛицо";
		ИначеЕсли Реквизиты.ЭтоИндивидуальныйПредприниматель Тогда
			Возврат "ИндивидуальныйПредприниматель";
		Иначе
			Возврат "ФизическоеЛицо";
		КонецЕсли;
	Иначе
		Если Реквизиты.ЭтоИностраннаяОрганизация Тогда
			Возврат "ИностраннаяОрганизация";
		ИначеЕсли Реквизиты.ЭтоФилиал Тогда
			Возврат "Филиал";
		ИначеЕсли Реквизиты.ЭтоИндивидуальныйПредприниматель Тогда
			Возврат "ИндивидуальныйПредприниматель";
		Иначе
			Возврат "РоссийскаяОрганизация";
		КонецЕсли;
	КонецЕсли;
	
КонецФункции

Процедура ТекстПроверкиМЧД(Результат, Верна, Проверка) Экспорт

	Если Результат.Верна = Истина Тогда

		Если Результат.СтатусВернаУстановленВручную Тогда
			Проверка = НСтр("ru = 'Проверена подпись по МЧД';
							|en = 'Signature of the machine-readable letter of authority is verified'");
		Иначе
			Проверка = НСтр("ru = 'Верна подпись по МЧД';
							|en = 'Signature of the machine-readable letter of authority is valid'");
		КонецЕсли;

	ИначеЕсли Результат.ТребуетсяПроверка = Истина Тогда
		Проверка = НСтр("ru = 'Требуется проверка подписи по МЧД';
						|en = 'Verify the signature of the machine-readable letter of authority'");
		Верна = Ложь;
	Иначе
		Проверка = НСтр("ru = 'Не верна подпись по МЧД';
						|en = 'Не верна подпись по МЧД'");
		Верна = Ложь;
	КонецЕсли;
	
КонецПроцедуры

Функция ТолькоЦифры(Строка) Экспорт
	
	ДлинаСтроки = СтрДлина(Строка);
	
	ОбработаннаяСтрока = "";
	Для НомерСимвола = 1 По ДлинаСтроки Цикл
		
		Символ = Сред(Строка, НомерСимвола, 1);
		Если Символ >= "0" И Символ <= "9" Тогда
			ОбработаннаяСтрока = ОбработаннаяСтрока + Символ;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ОбработаннаяСтрока;
КонецФункции
	
Функция ДатаОкончанияПериодаИстекающихДоверенностей(ДатаОтсчета) Экспорт
	Возврат ДатаОтсчета + 259200;
КонецФункции

// Результат проверки доверенности.
// 
// Параметры:
//  Результат - Структура
// 
// Возвращаемое значение:
//  Структура -  результат проверки доверенности:
//   * Верна - Булево
//   * ТекстОшибки - Строка 
//   * ЕстьВсеПодписи - Булево
//   * ЕстьВРеестреФНС - Булево
//   * Статус - ПеречислениеСсылка.СтатусыМЧД 
//   * ТребуетсяПроверка - Булево 
//   * РезультатыПроверкиПодписей - Массив из Структура
//   * ОписаниеОшибок - см. НовоеОписаниеОшибок
//
Функция РезультатПроверкиДоверенности(Результат) Экспорт
	
	РезультатПроверкиПодписей = Результат.РезультатПроверкиПодписей;
	СтатусВернаУстановленВручную = Результат.СтатусВернаУстановленВручную;
	
	РезультатПроверкиДоверенности = Новый Структура;
	РезультатПроверкиДоверенности.Вставить("Верна");
	РезультатПроверкиДоверенности.Вставить("ТекстОшибки", "");
	РезультатПроверкиДоверенности.Вставить("ОписаниеОшибок");
	РезультатПроверкиДоверенности.Вставить("ЕстьВсеПодписи", Ложь);
	РезультатПроверкиДоверенности.Вставить("ЕстьВРеестреФНС", Результат.ЕстьВРеестреФНС);
	РезультатПроверкиДоверенности.Вставить("Статус");
	РезультатПроверкиДоверенности.Вставить("ТребуетсяПроверка", Ложь);
	РезультатПроверкиДоверенности.Вставить("РезультатыПроверкиПодписей", Новый Массив);
	
	ОписаниеОшибок = НовоеОписаниеОшибок();
	
	Если Результат.ВыполненаПроверкаПодписей Тогда
		
		РезультатПроверкиДоверенности.РезультатыПроверкиПодписей = РезультатПроверкиПодписей.РезультатыПроверкиПодписей;
		РезультатПроверкиДоверенности.ЕстьВсеПодписи = РезультатПроверкиПодписей.ЕстьВсеПодписи;
		
		ПодписиВерны = Истина; ПодписиСоответствуют = Истина; ПодписиТребуютПроверки = Ложь;
			
		Для Каждого РезультатПроверкиПодписи Из РезультатПроверкиПодписей.РезультатыПроверкиПодписей Цикл
			
			Если РезультатПроверкиПодписи.ТребуетсяПроверка Тогда
				ПодписиТребуютПроверки = Истина;
			ИначеЕсли Не РезультатПроверкиПодписи.ПодписьВерна Тогда
				ПодписиВерны = Ложь;
			КонецЕсли;
			
			Если Не РезультатПроверкиПодписи.Соответствует Тогда
				ПодписиСоответствуют = Ложь;
			КонецЕсли;
		
		КонецЦикла;
		
		РезультатПроверкиДоверенности.Верна = (СтатусВернаУстановленВручную
			Или ПодписиВерны И ПодписиСоответствуют И Не ПодписиТребуютПроверки И РезультатПроверкиПодписей.ЕстьВсеПодписи)
			И Не ЗначениеЗаполнено(Результат.ОшибкаПроверкиВРеестреФНС);
		
		РезультатПроверкиДоверенности.ТребуетсяПроверка = Не СтатусВернаУстановленВручную И ПодписиТребуютПроверки
			Или ЗначениеЗаполнено(Результат.ОшибкаПроверкиВРеестреФНС);
	Иначе
		
		РезультатПроверкиДоверенности.Верна = Результат.СтатусВернаИзДанныхДоверенности;
		РезультатПроверкиДоверенности.ТребуетсяПроверка = Не ЗначениеЗаполнено(Результат.ДатаПроверкиИзДанныхДоверенности)
			Или ЗначениеЗаполнено(Результат.ОшибкаПроверкиВРеестреФНС);
		
	КонецЕсли;
	
	Если Результат.Статус = ПредопределенноеЗначение("Перечисление.СтатусыМЧД.Действует")
		И Не РезультатПроверкиДоверенности.Верна Тогда
		РезультатПроверкиДоверенности.Статус = ПредопределенноеЗначение("Перечисление.СтатусыМЧД.НеДействует");
	Иначе
		РезультатПроверкиДоверенности.Статус = Результат.Статус;
	КонецЕсли;

	Если Не РезультатПроверкиДоверенности.Верна Или СтатусВернаУстановленВручную Тогда
		
		Ошибки = Новый Массив;

		Если СтатусВернаУстановленВручную Тогда
			
			ОписаниеОшибки = НовыеСвойстваОшибки();
			ОписаниеОшибки.Описание = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Статус Верна установлен вручную (%1)';
					|en = 'The Valid status is set manually (%1)'"), Результат.УстановившийСтатусВерна);
			ОписаниеОшибок.Ошибки.Добавить(ОписаниеОшибки);
			
			Ошибки.Добавить(ОписаниеОшибки.Описание);
			
		ИначеЕсли Результат.ВыполненаПроверкаПодписей Тогда
			
			Если ПодписиТребуютПроверки Тогда
				
				ОписаниеОшибки = НовыеСвойстваОшибки();
				ОписаниеОшибки.Описание = НСтр("ru = 'Есть подписи доверителей, требующие проверки';
												|en = 'There are principals'' signatures that require verification'");
				ОписаниеОшибок.Ошибки.Добавить(ОписаниеОшибки);
				Ошибки.Добавить(ОписаниеОшибки.Описание);
			КонецЕсли;
			
			Если Не ПодписиВерны Тогда
				
				ОписаниеОшибки = НовыеСвойстваОшибки();
				ОписаниеОшибки.Описание = НСтр("ru = 'Есть недействительные подписи доверителей';
												|en = 'There are invalid principals'' signatures'");
				ОписаниеОшибок.Ошибки.Добавить(ОписаниеОшибки);
				Ошибки.Добавить(ОписаниеОшибки.Описание);
			КонецЕсли;
			
			Если Не ПодписиСоответствуют Тогда
				
				ОписаниеОшибки = НовыеСвойстваОшибки();
				ОписаниеОшибки.Описание = НСтр("ru = 'Есть подписи доверителей, не соответствующие доверенности';
												|en = 'There are principals'' signatures that do not correspond to the letter of authority'");
				ОписаниеОшибок.Ошибки.Добавить(ОписаниеОшибки);
				Ошибки.Добавить(ОписаниеОшибки.Описание);
			КонецЕсли;
			
			Если Не РезультатПроверкиПодписей.ЕстьВсеПодписи Тогда
				
				ОписаниеОшибки = НовыеСвойстваОшибки();
				ОписаниеОшибки.Описание = РезультатПроверкиПодписей.ТекстОшибки;
				ОписаниеОшибок.Ошибки.Добавить(ОписаниеОшибки);
				Ошибки.Добавить(ОписаниеОшибки.Описание);
			КонецЕсли;
			
		ИначеЕсли Не ЗначениеЗаполнено(Результат.ДатаПроверкиИзДанныхДоверенности) Тогда
			
			ОписаниеОшибки = НовыеСвойстваОшибки();
			ОписаниеОшибки.Описание = НСтр("ru = 'Статус доверенности в программе - требуется проверка';
											|en = 'Status of the letter of authority in the application - verification required'");
			ОписаниеОшибок.Ошибки.Добавить(ОписаниеОшибки);
			Ошибки.Добавить(ОписаниеОшибки.Описание);
		Иначе
			
			ОписаниеОшибки = НовыеСвойстваОшибки();
			ОписаниеОшибки.Описание = НСтр("ru = 'Статус доверенности в программе - не верна';
											|en = 'Status of the letter of authority in the application - invalid'");
			ОписаниеОшибок.Ошибки.Добавить(ОписаниеОшибки);
			Ошибки.Добавить(ОписаниеОшибки.Описание);
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Результат.ОшибкаПроверкиВРеестреФНС) Тогда
			
			ОписаниеОшибки = НовыеСвойстваОшибки();
			ОписаниеОшибки.Описание = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось проверить доверенность в реестре ФНС: %1';
					|en = 'Cannot verify the letter of authority in the FTS registry: %1'"), Результат.ОшибкаПроверкиВРеестреФНС);
			ОписаниеОшибок.Ошибки.Добавить(ОписаниеОшибки);
			Ошибки.Добавить(ОписаниеОшибки.Описание);
			
		КонецЕсли;
		
		РезультатПроверкиДоверенности.ОписаниеОшибок = ОписаниеОшибок;
		РезультатПроверкиДоверенности.ТекстОшибки =  СтрСоединить(Ошибки, "; ");
	КонецЕсли;
	
	Возврат РезультатПроверкиДоверенности;
	
КонецФункции

//  Возвращаемое значение:
//   Структура - содержит ошибки выполнения проверок:
//     * ОписаниеОшибки  - Строка - полное описание ошибки, когда оно возвращается строкой.
//     * ЗаголовокОшибки - Строка - заголовок ошибки, который соответствует операции
//                                  когда операция одна (не заполнен, когда операций несколько).
//     * Ошибки          - Массив из см. НовыеСвойстваОшибки
//
Функция НовоеОписаниеОшибок() Экспорт
	
	Описание = Новый Структура;
	Описание.Вставить("ОписаниеОшибки",  "");
	Описание.Вставить("ЗаголовокОшибки", "");
	Описание.Вставить("Ошибки", Новый Массив);
	
	Возврат Описание;
	
КонецФункции

// Возвращает свойства ошибки выполнения одной проверки.
//
// Возвращаемое значение:
//  Структура:
//   * ЗаголовокОшибки   - Строка - заголовок ошибки, который соответствует операции
//                           когда операций несколько (не заполнен, когда операция одна).
//   * Описание          - Строка - краткое представление ошибки.
//
Функция НовыеСвойстваОшибки() Экспорт
	
	СвойстваОшибки = Новый Структура;
	СвойстваОшибки.Вставить("ЗаголовокОшибки",   "");
	СвойстваОшибки.Вставить("Описание",          "");
	
	Возврат СвойстваОшибки;
	
КонецФункции

#КонецОбласти
