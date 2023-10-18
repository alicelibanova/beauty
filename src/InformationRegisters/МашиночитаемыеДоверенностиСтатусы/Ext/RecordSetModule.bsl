﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОтборПоДоверенности = Отбор.Найти("МашиночитаемаяДоверенность");
	Записи = Выгрузить();
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Записи.МашиночитаемаяДоверенность КАК МашиночитаемаяДоверенность,
	               |	Записи.ТехническийСтатус КАК НовыйСтатус
	               |ПОМЕСТИТЬ ВТЗаписи
	               |ИЗ
	               |	&Записи КАК Записи
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ЕСТЬNULL(ТекущиеЗаписи.МашиночитаемаяДоверенность, ВТЗаписи.МашиночитаемаяДоверенность) КАК МашиночитаемаяДоверенность,
	               |	ТекущиеЗаписи.СтатусДоИзменения КАК СтатусДоИзменения,
	               |	ВТЗаписи.НовыйСтатус КАК НовыйСтатус
	               |ИЗ
	               |	(ВЫБРАТЬ
	               |		МашиночитаемыеДоверенностиСтатусы.ТехническийСтатус КАК СтатусДоИзменения,
	               |		МашиночитаемыеДоверенностиСтатусы.МашиночитаемаяДоверенность КАК МашиночитаемаяДоверенность
	               |	ИЗ
	               |		РегистрСведений.МашиночитаемыеДоверенностиСтатусы КАК МашиночитаемыеДоверенностиСтатусы
	               |	ГДЕ
	               |		(&МашиночитаемаяДоверенность = НЕОПРЕДЕЛЕНО
	               |				ИЛИ МашиночитаемыеДоверенностиСтатусы.МашиночитаемаяДоверенность = &МашиночитаемаяДоверенность)) КАК ТекущиеЗаписи
	               |		ПОЛНОЕ СОЕДИНЕНИЕ ВТЗаписи КАК ВТЗаписи
	               |		ПО ТекущиеЗаписи.МашиночитаемаяДоверенность = ВТЗаписи.МашиночитаемаяДоверенность
	               |ГДЕ
	               |	ЕСТЬNULL(ВТЗаписи.НовыйСтатус, ЗНАЧЕНИЕ(Перечисление.ТехническиеСтатусыМЧД.ПустаяСсылка)) <> ЕСТЬNULL(ТекущиеЗаписи.СтатусДоИзменения, ЗНАЧЕНИЕ(Перечисление.ТехническиеСтатусыМЧД.ПустаяСсылка))";
	
	Если ОтборПоДоверенности = Неопределено Тогда
		Запрос.УстановитьПараметр("МашиночитаемаяДоверенность", Неопределено);
	Иначе
		Запрос.УстановитьПараметр("МашиночитаемаяДоверенность", ОтборПоДоверенности.Значение);
	КонецЕсли;
	Запрос.УстановитьПараметр("Записи", Записи);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	ИзменившиесяСтатусы = Новый Соответствие;
	
	Пока Выборка.Следующий() Цикл
		Статусы = Новый Структура;
		Статусы.Вставить("СтатусДоИзменения", Выборка.СтатусДоИзменения);
		Статусы.Вставить("НовыйСтатус", Выборка.НовыйСтатус);
		ИзменившиесяСтатусы.Вставить(Выборка.МашиночитаемаяДоверенность, Статусы);
	КонецЦикла; 
	
	Если ИзменившиесяСтатусы.Количество() > 0 Тогда
		МашиночитаемыеДоверенностиФНССлужебный.ПриИзмененииСтатусаДоверенности(ИзменившиесяСтатусы);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.';
						|en = 'Invalid object call on the client.'");
#КонецЕсли
