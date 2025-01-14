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
	
	Элементы.НеразделенныйПользователь.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Просмотр сведений о пользователе %1 не доступен, т.к. это 
		           |служебная учетная запись, предусмотренная для администраторов сервиса.';
		           |en = 'View of user information %1 is not available as it is a 
		           |service account provided for SaaS administrators.'"),
		Параметры.Ключ.Наименование);
	
КонецПроцедуры

#КонецОбласти