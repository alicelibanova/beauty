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
	
	Если НЕ Параметры.Свойство("ОткрытаПоСценарию") Тогда
		ВызватьИсключение НСтр("ru = 'Обработка не предназначена для непосредственного использования.';
								|en = 'The data processor cannot be opened manually.'");
	КонецЕсли;
	
	ПропуститьЗавершениеРаботы = Параметры.ПропуститьЗавершениеРаботы;
	
	Элементы.ТекстСообщения.Заголовок = Параметры.ТекстСообщения;
	СистемнаяИнформация = Новый СистемнаяИнформация;
	Текущая       = СистемнаяИнформация.ВерсияПриложения;
	Минимальная   = Параметры.МинимальнаяВерсияПлатформы;
	Рекомендуемая = Параметры.РекомендуемаяВерсияПлатформы;
	
	Элементы.ТекстСообщения.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		Элементы.ТекстСообщения.Заголовок, Минимальная);
	
	НомерВерсии   = Рекомендуемая;
	ПродолжениеРаботыНевозможно = Ложь;
	Если ОбщегоНазначенияКлиентСервер.СравнитьВерсии(Текущая, Минимальная) < 0 Тогда
		ТекстУсловие                = НСтр("ru = 'необходимо';
											|en = 'required'");
		ПродолжениеРаботыНевозможно = Истина;
		НомерВерсии = Минимальная;
	Иначе
		ТекстУсловие = НСтр("ru = 'рекомендуется';
							|en = 'recommended'");
	КонецЕсли;
	Элементы.Версия.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		Элементы.Версия.Заголовок,
		ТекстУсловие, НомерВерсии,
		СистемнаяИнформация.ВерсияПриложения);
	
	Если ПродолжениеРаботыНевозможно Тогда
		Элементы.ТекстВопроса.Видимость = Ложь;
		Элементы.ФормаНет.Видимость     = Ложь;
		Заголовок = НСтр("ru = 'Необходимо обновить версию платформы';
						|en = '1C:Enterprise update required'");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если Не ДействиеОпределено Тогда
		ДействиеОпределено = Истина;
		
		Если НЕ ПропуститьЗавершениеРаботы Тогда
			ПрекратитьРаботуСистемы();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТекстСсылкиНажатие(Элемент)
	
	ОткрытьФорму("Обработка.НерекомендуемаяВерсияПлатформы.Форма.ПорядокОбновленияПлатформы",,ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПродолжитьРаботу(Команда)
	
	ДействиеОпределено = Истина;
	Закрыть("Продолжить");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьРаботу(Команда)
	
	ДействиеОпределено = Истина;
	Если НЕ ПропуститьЗавершениеРаботы Тогда
		ПрекратитьРаботуСистемы();
	КонецЕсли;
	Закрыть();
	
КонецПроцедуры

#КонецОбласти
