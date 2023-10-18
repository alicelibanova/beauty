﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

Функция ФлагНастройкиНеПредлагатьПерейтиНаВебСервис(ОбъектНастройки, Значение = Неопределено) Экспорт
	
	Если ТипЗнч(ОбъектНастройки) = Тип("Строка") Тогда
		Ключ = "НеПредлагатьПерейтиНаВебСервис" + ОбъектНастройки;
	Иначе
		Ключ = "НеПредлагатьПерейтиНаВебСервис" + ОбъектНастройки.УникальныйИдентификатор();
	КонецЕсли;
	
	Если Значение = Неопределено Тогда
		// Чтение
		Возврат ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("НастройкиПрограммы", Ключ, Ложь,, ИмяПользователя());
	КонецЕсли;
	
	ОписаниеНастроек = НСтр("ru = 'Не предлагать перейти на веб-сервис';
							|en = 'Do not offer to switch to a web service'");
	
	// Запись
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("НастройкиПрограммы", Ключ, Значение, ОписаниеНастроек, ИмяПользователя());
	
КонецФункции

#КонецОбласти