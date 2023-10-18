﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Параметры:
//   Настройки - см. ЭлектроннаяПодписьСлужебный.ПоставляемыеНастройкиПрограмм
//
Процедура ДобавитьПоставляемыеНастройкиПрограмм(Настройки) Экспорт
	
	// ViPNet CSP (ГОСТ 2012/256).
	Настройка = Настройки.Добавить();
	Настройка.Представление       = НСтр("ru = 'ViPNet CSP (ГОСТ 2012/256)';
										|en = 'ViPNet CSP (GOST 2012/256)'");
	Настройка.ИмяПрограммы        = "Infotecs GOST 2012/512 Cryptographic Service Provider";
	Настройка.ТипПрограммы        = 77;
	// Варианты: GR 34.10-2012 256
	Настройка.АлгоритмПодписи     = "GR 34.10-2012 256";
	// Варианты: GR 34.11-2012 256, GOST R 34.11-94, GR 34.11-2012 512.
	Настройка.АлгоритмХеширования = "GR 34.11-2012 256";
	Настройка.АлгоритмШифрования  = "GOST 28147-89"; // Один вариант.
	Настройка.Идентификатор       = "VipNet2012";
	
	Настройка.АлгоритмыПодписи.Добавить("GR 34.10-2012 256");
	Настройка.АлгоритмыХеширования.Добавить("GR 34.11-2012 256");
	Настройка.АлгоритмыХеширования.Добавить("GOST R 34.11-94");
	Настройка.АлгоритмыХеширования.Добавить("GR 34.11-2012 512");
	Настройка.АлгоритмыШифрования.Добавить("GOST 28147-89");
	
	// ViPNet CSP (ГОСТ 2012/512).
	Настройка = Настройки.Добавить();
	Настройка.Представление       = НСтр("ru = 'ViPNet CSP (ГОСТ 2012/512)';
										|en = 'ViPNet CSP (GOST 2012/512)'");
	Настройка.ИмяПрограммы        = "Infotecs GOST 2012/1024 Cryptographic Service Provider";
	Настройка.ТипПрограммы        = 78;
	// Варианты: GR 34.10-2012 512
	Настройка.АлгоритмПодписи     = "GR 34.10-2012 512";
	// Варианты: GR 34.11-2012 512, GOST R 34.11-94, GR 34.11-2012 256.
	Настройка.АлгоритмХеширования = "GR 34.11-2012 512";
	Настройка.АлгоритмШифрования  = "GOST 28147-89"; // Один вариант.
	Настройка.Идентификатор       = "VipNet2012_512";
	
	Настройка.АлгоритмыПодписи.Добавить("GR 34.10-2012 512");
	Настройка.АлгоритмыХеширования.Добавить("GR 34.11-2012 512");
	Настройка.АлгоритмыХеширования.Добавить("GOST R 34.11-94");
	Настройка.АлгоритмыХеширования.Добавить("GR 34.11-2012 256");
	Настройка.АлгоритмыШифрования.Добавить("GOST 28147-89");
	
	// КриптоПро CSP (ГОСТ 2012/256).
	Настройка = Настройки.Добавить();
	Настройка.Представление       = НСтр("ru = 'КриптоПро CSP (ГОСТ 2012/256)';
										|en = 'CryptoPro CSP (GOST 2012/256)'");
	Настройка.ИмяПрограммы        = "Crypto-Pro GOST R 34.10-2012 Cryptographic Service Provider";
	Настройка.ТипПрограммы        = 80;
	Настройка.АлгоритмПодписи     = "GR 34.10-2012 256";
	Настройка.АлгоритмХеширования = "GR 34.11-2012 256";
	Настройка.АлгоритмШифрования  = "GOST 28147-89";
	Настройка.Идентификатор       = "CryptoPro2012";
	
	Настройка.АлгоритмыПодписи.Добавить("GR 34.10-2012 256");
	Настройка.АлгоритмыХеширования.Добавить("GR 34.11-2012 256");
	Настройка.АлгоритмыШифрования.Добавить("GOST 28147-89");
	Настройка.АлгоритмыПроверкиПодписи.Добавить("GOST R 34.10-2001");
	Настройка.АлгоритмыПроверкиПодписи.Добавить("GR 34.10-2012 512");

	// КриптоПро CSP (ГОСТ 2012/256) KC1.
	Настройка = Настройки.Добавить();
	Настройка.Представление       = НСтр("ru = 'КриптоПро CSP (ГОСТ 2012/256) KC1';
										|en = 'CryptoPro CSP (GOST 2012/256) KC1'");
	Настройка.ИмяПрограммы        = "Crypto-Pro GOST R 34.10-2012 KC1 CSP";
	Настройка.ТипПрограммы        = 80;
	Настройка.АлгоритмПодписи     = "GR 34.10-2012 256";
	Настройка.АлгоритмХеширования = "GR 34.11-2012 256";
	Настройка.АлгоритмШифрования  = "GOST 28147-89";
	Настройка.Идентификатор       = "CryptoPro2012_KC1";
	
	Настройка.АлгоритмыПодписи.Добавить("GR 34.10-2012 256");
	Настройка.АлгоритмыХеширования.Добавить("GR 34.11-2012 256");
	Настройка.АлгоритмыШифрования.Добавить("GOST 28147-89");
	Настройка.АлгоритмыПроверкиПодписи.Добавить("GOST R 34.10-2001");
	Настройка.АлгоритмыПроверкиПодписи.Добавить("GR 34.10-2012 512");
	Настройка.НетВWindows = Истина;
	
	// КриптоПро CSP (ГОСТ 2012/256) KC2.
	Настройка = Настройки.Добавить();
	Настройка.Представление       = НСтр("ru = 'КриптоПро CSP (ГОСТ 2012/256) KC2';
										|en = 'CryptoPro CSP (GOST 2012/256) KC2'");
	Настройка.ИмяПрограммы        = "Crypto-Pro GOST R 34.10-2012 KC2 CSP";
	Настройка.ТипПрограммы        = 80;
	Настройка.АлгоритмПодписи     = "GR 34.10-2012 256";
	Настройка.АлгоритмХеширования = "GR 34.11-2012 256";
	Настройка.АлгоритмШифрования  = "GOST 28147-89";
	Настройка.Идентификатор       = "CryptoPro2012_KC2";
	
	Настройка.АлгоритмыПодписи.Добавить("GR 34.10-2012 256");
	Настройка.АлгоритмыХеширования.Добавить("GR 34.11-2012 256");
	Настройка.АлгоритмыШифрования.Добавить("GOST 28147-89");
	Настройка.АлгоритмыПроверкиПодписи.Добавить("GOST R 34.10-2001");
	Настройка.АлгоритмыПроверкиПодписи.Добавить("GR 34.10-2012 512");
	Настройка.НетВWindows = Истина;
	
	// КриптоПро CSP (ГОСТ 2012/512).
	Настройка = Настройки.Добавить();
	Настройка.Представление       = НСтр("ru = 'КриптоПро CSP (ГОСТ 2012/512)';
										|en = 'CryptoPro CSP (GOST 2012/512)'");
	Настройка.ИмяПрограммы        = "Crypto-Pro GOST R 34.10-2012 Strong Cryptographic Service Provider";
	Настройка.ТипПрограммы        = 81;
	Настройка.АлгоритмПодписи     = "GR 34.10-2012 512";
	Настройка.АлгоритмХеширования = "GR 34.11-2012 512";
	Настройка.АлгоритмШифрования  = "GOST 28147-89";
	Настройка.Идентификатор       = "CryptoPro2012_512";
	
	Настройка.АлгоритмыПодписи.Добавить("GR 34.10-2012 512");
	Настройка.АлгоритмыХеширования.Добавить("GR 34.11-2012 512");
	Настройка.АлгоритмыШифрования.Добавить("GOST 28147-89");
	Настройка.АлгоритмыПроверкиПодписи.Добавить("GOST R 34.10-2001");
	Настройка.АлгоритмыПроверкиПодписи.Добавить("GR 34.10-2012 256");
	
	// КриптоПро CSP (ГОСТ 2012/512) KC1.
	Настройка = Настройки.Добавить();
	Настройка.Представление       = НСтр("ru = 'КриптоПро CSP (ГОСТ 2012/512) KC1';
										|en = 'CryptoPro CSP (GOST 2012/512) KC1'");
	Настройка.ИмяПрограммы        = "Crypto-Pro GOST R 34.10-2012 KC1 Strong CSP";
	Настройка.ТипПрограммы        = 81;
	Настройка.АлгоритмПодписи     = "GR 34.10-2012 512";
	Настройка.АлгоритмХеширования = "GR 34.11-2012 512";
	Настройка.АлгоритмШифрования  = "GOST 28147-89";
	Настройка.Идентификатор       = "CryptoPro2012_512_KC1";
	
	Настройка.АлгоритмыПодписи.Добавить("GR 34.10-2012 512");
	Настройка.АлгоритмыХеширования.Добавить("GR 34.11-2012 512");
	Настройка.АлгоритмыШифрования.Добавить("GOST 28147-89");
	Настройка.АлгоритмыПроверкиПодписи.Добавить("GOST R 34.10-2001");
	Настройка.АлгоритмыПроверкиПодписи.Добавить("GR 34.10-2012 256");
	Настройка.НетВWindows = Истина;
	
	// КриптоПро CSP (ГОСТ 2012/512) KC2.
	Настройка = Настройки.Добавить();
	Настройка.Представление       = НСтр("ru = 'КриптоПро CSP (ГОСТ 2012/512) KC2';
										|en = 'CryptoPro CSP (GOST 2012/512) KC2'");
	Настройка.ИмяПрограммы        = "Crypto-Pro GOST R 34.10-2012 KC2 Strong CSP";
	Настройка.ТипПрограммы        = 81;
	Настройка.АлгоритмПодписи     = "GR 34.10-2012 512";
	Настройка.АлгоритмХеширования = "GR 34.11-2012 512";
	Настройка.АлгоритмШифрования  = "GOST 28147-89";
	Настройка.Идентификатор       = "CryptoPro2012_512_KC2";
	
	Настройка.АлгоритмыПодписи.Добавить("GR 34.10-2012 512");
	Настройка.АлгоритмыХеширования.Добавить("GR 34.11-2012 512");
	Настройка.АлгоритмыШифрования.Добавить("GOST 28147-89");
	Настройка.АлгоритмыПроверкиПодписи.Добавить("GOST R 34.10-2001");
	Настройка.АлгоритмыПроверкиПодписи.Добавить("GR 34.10-2012 256");
	Настройка.НетВWindows = Истина;
	
	// КриптоПро eToken CSP.
	Настройка = Настройки.Добавить();
	Настройка.Представление       = НСтр("ru = 'eToken Base CSP';
										|en = 'eToken Base CSP'");
	Настройка.ИмяПрограммы        = "eToken Base Cryptographic Provider";
	Настройка.ТипПрограммы        = 1;
	Настройка.АлгоритмПодписи     = "RSA_SIGN";
	Настройка.АлгоритмХеширования = "SHA-1";
	Настройка.АлгоритмШифрования  = "DES";
	Настройка.Идентификатор       = "eToken";
	
	// Microsoft Enhanced CSP.
	Справочники.ПрограммыЭлектроннойПодписиИШифрования.ДобавитьНастройкиMicrosoftEnhancedCSP(Настройки);
	
	// ЛИССИ CSP (ГОСТ 2012/256).
	Настройка = Настройки.Добавить();
	Настройка.Представление       = НСтр("ru = 'ЛИССИ CSP (ГОСТ 2012/256)';
										|en = 'LISSI-CSP (GOST 2012/256)'");
	Настройка.ИмяПрограммы        = "LISSI GOST R 34.10-2012 (256) CSP";
	Настройка.ТипПрограммы        = 80;
	Настройка.АлгоритмПодписи     = "GOST R 34.10-12 256";
	Настройка.АлгоритмХеширования = "GOST R 34.11-12 256";
	Настройка.АлгоритмШифрования  = "GOST 28147-89";
	Настройка.Идентификатор       = "Lissi2012";
	
	Настройка.АлгоритмыПодписи.Добавить("GOST R 34.10-12 256");
	Настройка.АлгоритмыХеширования.Добавить("GOST R 34.11-12 256");
	Настройка.АлгоритмыШифрования.Добавить("GOST 28147-89");
	
	// Сигнал-КОМ CSP (RFC 4357, ГОСТ 2012/256).
	Настройка = Настройки.Добавить();
	Настройка.Представление       = НСтр("ru = 'Сигнал-КОМ CSP (ГОСТ 2012/256)';
										|en = 'Signal-COM CSP (GOST 2012/256)'");
	Настройка.ИмяПрограммы        = "Signal-COM GOST R 34.10-2012 (256) Cryptographic Provider";
	Настройка.ТипПрограммы        = 80;
	Настройка.АлгоритмПодписи     = "GOST3410-12-256";
	Настройка.АлгоритмХеширования = "GOST3411-12-256";
	Настройка.АлгоритмШифрования  = "GOST28147";
	Настройка.Идентификатор       = "SignalComCPGOST2012";
	
	Настройка.АлгоритмыПодписи.Добавить("GOST3410-12-256");
	Настройка.АлгоритмыХеширования.Добавить("GOST3411-12-256");
	Настройка.АлгоритмыШифрования.Добавить("GOST28147");
	
	// ViPNet CSP (ГОСТ 2001).
	Настройка = Настройки.Добавить();
	Настройка.Представление       = НСтр("ru = 'ViPNet CSP (ГОСТ 2001)';
										|en = 'ViPNet CSP (GOST 2001)'");
	Настройка.ИмяПрограммы        = "Infotecs Cryptographic Service Provider";
	Настройка.ТипПрограммы        = 2;
	// Варианты: GOST R 34.10-2001
	Настройка.АлгоритмПодписи     = "GOST R 34.10-2001";
	// Варианты: GOST R 34.11-94, GR 34.11-2012 256, GR 34.11-2012 512.
	Настройка.АлгоритмХеширования = "GOST R 34.11-94";
	Настройка.АлгоритмШифрования  = "GOST 28147-89";     // Один вариант.
	Настройка.Идентификатор       = "VipNet2001";
	
	Настройка.АлгоритмыПодписи.Добавить("GOST R 34.10-2001");
	Настройка.АлгоритмыХеширования.Добавить("GOST R 34.11-94");
	Настройка.АлгоритмыХеширования.Добавить("GR 34.11-2012 256");
	Настройка.АлгоритмыХеширования.Добавить("GR 34.11-2012 512");
	Настройка.АлгоритмыШифрования.Добавить("GOST 28147-89");
	
	// КриптоПро CSP (ГОСТ 2001).
	Настройка = Настройки.Добавить();
	Настройка.Представление       = НСтр("ru = 'КриптоПро CSP (ГОСТ 2001)';
										|en = 'CryptoPro CSP (GOST 2001)'");
	Настройка.ИмяПрограммы        = "Crypto-Pro GOST R 34.10-2001 Cryptographic Service Provider";
	Настройка.ТипПрограммы        = 75;
	Настройка.АлгоритмПодписи     = "GOST R 34.10-2001";
	Настройка.АлгоритмХеширования = "GOST R 34.11-94";
	Настройка.АлгоритмШифрования  = "GOST 28147-89";
	Настройка.Идентификатор       = "CryptoPro2001";
	
	Настройка.АлгоритмыПодписи.Добавить("GOST R 34.10-2001");
	Настройка.АлгоритмыХеширования.Добавить("GOST R 34.11-94");
	Настройка.АлгоритмыШифрования.Добавить("GOST 28147-89");
	Настройка.АлгоритмыПроверкиПодписи.Добавить("GR 34.10-2012 256");
	Настройка.АлгоритмыПроверкиПодписи.Добавить("GR 34.10-2012 512");
	
	// КриптоПро CSP (ГОСТ 2001) KC1.
	Настройка = Настройки.Добавить();
	Настройка.Представление       = НСтр("ru = 'КриптоПро CSP (ГОСТ 2001) KC1';
										|en = 'CryptoPro CSP (GOST 2001) KC1'");
	Настройка.ИмяПрограммы        = "Crypto-Pro GOST R 34.10-2001 KC1 CSP";
	Настройка.ТипПрограммы        = 75;
	Настройка.АлгоритмПодписи     = "GOST R 34.10-2001";
	Настройка.АлгоритмХеширования = "GOST R 34.11-94";
	Настройка.АлгоритмШифрования  = "GOST 28147-89";
	Настройка.Идентификатор       = "CryptoPro2001";
	
	Настройка.АлгоритмыПодписи.Добавить("GOST R 34.10-2001");
	Настройка.АлгоритмыХеширования.Добавить("GOST R 34.11-94");
	Настройка.АлгоритмыШифрования.Добавить("GOST 28147-89");
	Настройка.АлгоритмыПроверкиПодписи.Добавить("GR 34.10-2012 256");
	Настройка.АлгоритмыПроверкиПодписи.Добавить("GR 34.10-2012 512");
	Настройка.НетВWindows = Истина;
	
	// КриптоПро CSP (ГОСТ 2001) KC2.
	Настройка = Настройки.Добавить();
	Настройка.Представление       = НСтр("ru = 'КриптоПро CSP (ГОСТ 2001) KC2';
										|en = 'CryptoPro CSP (GOST 2001) KC2'");
	Настройка.ИмяПрограммы        = "Crypto-Pro GOST R 34.10-2001 KC2 CSP";
	Настройка.ТипПрограммы        = 75;
	Настройка.АлгоритмПодписи     = "GOST R 34.10-2001";
	Настройка.АлгоритмХеширования = "GOST R 34.11-94";
	Настройка.АлгоритмШифрования  = "GOST 28147-89";
	Настройка.Идентификатор       = "CryptoPro2001";
	
	Настройка.АлгоритмыПодписи.Добавить("GOST R 34.10-2001");
	Настройка.АлгоритмыХеширования.Добавить("GOST R 34.11-94");
	Настройка.АлгоритмыШифрования.Добавить("GOST 28147-89");
	Настройка.АлгоритмыПроверкиПодписи.Добавить("GR 34.10-2012 256");
	Настройка.АлгоритмыПроверкиПодписи.Добавить("GR 34.10-2012 512");
	Настройка.НетВWindows = Истина;
	
	// ЛИССИ CSP (ГОСТ 2001).
	Настройка = Настройки.Добавить();
	Настройка.Представление       = НСтр("ru = 'ЛИССИ CSP (ГОСТ 2001)';
										|en = 'LISSI CSP (GOST 2001)'");
	Настройка.ИмяПрограммы        = "LISSI-CSP";
	Настройка.ТипПрограммы        = 75;
	Настройка.АлгоритмПодписи     = "GOST R 34.10-2001";
	Настройка.АлгоритмХеширования = "GOST R 34.11-94";
	Настройка.АлгоритмШифрования  = "GOST 28147-89";
	Настройка.Идентификатор       = "Lissi2001";
	
	Настройка.АлгоритмыПодписи.Добавить("GOST R 34.10-2001");
	Настройка.АлгоритмыХеширования.Добавить("GOST R 34.11-94");
	Настройка.АлгоритмыШифрования.Добавить("GOST 28147-89");
	
	// Сигнал-КОМ CSP (RFC 4357, ГОСТ 2001).
	Настройка = Настройки.Добавить();
	Настройка.Представление       = НСтр("ru = 'Сигнал-КОМ CSP (RFC 4357, ГОСТ 2001)';
										|en = 'Signal-COM CSP (RFC 4357, GOST 2001)'");
	Настройка.ИмяПрограммы        = "Signal-COM CPGOST Cryptographic Provider";
	Настройка.ТипПрограммы        = 75;
	Настройка.АлгоритмПодписи     = "ECR3410-CP";
	Настройка.АлгоритмХеширования = "RUS-HASH-CP";
	Настройка.АлгоритмШифрования  = "GOST28147";
	Настройка.Идентификатор       = "SignalComCPGOST2001";
	
	Настройка.АлгоритмыПодписи.Добавить("ECR3410-CP");
	Настройка.АлгоритмыХеширования.Добавить("RUS-HASH-CP");
	Настройка.АлгоритмыШифрования.Добавить("GOST28147");
	
	// Сигнал-КОМ CSP (ITU-T X.509 v.3, ГОСТ 2001).
	Настройка = Настройки.Добавить();
	Настройка.Представление       = НСтр("ru = 'Сигнал-КОМ CSP (ITU-T X.509 v.3, ГОСТ 2001)';
										|en = 'Signal-COM CSP (ITU-T X.509 v.3, GOST 2001)'");
	Настройка.ИмяПрограммы        = "Signal-COM ECGOST Cryptographic Provider";
	Настройка.ТипПрограммы        = 129;
	Настройка.АлгоритмПодписи     = "ECR3410";
	Настройка.АлгоритмХеширования = "RUS-HASH";
	Настройка.АлгоритмШифрования  = "GOST28147";
	Настройка.Идентификатор       = "SignalComECGOST2001";
	
	Настройка.АлгоритмыПодписи.Добавить("ECR3410");
	Настройка.АлгоритмыХеширования.Добавить("RUS-HASH");
	Настройка.АлгоритмыШифрования.Добавить("GOST28147");
	
КонецПроцедуры

Процедура ДобавитьПоставляемыеПутиКМодулямПрограмм(ПутиКМодулям) Экспорт
	
	ПутиКриптоПро = Новый Соответствие;
	
	ПутиКриптоПро.Вставить("Linux_x86",    ПутиКМодулямПрограммыКриптоПроНаLinux32());
	ПутиКриптоПро.Вставить("Linux_x86_64", ПутиКМодулямПрограммыКриптоПроНаLinux64());
	ПутиКриптоПро.Вставить("MacOS_x86",    ПутиКМодулямПрограммыКриптоПроНаMacOS());
	ПутиКриптоПро.Вставить("MacOS_x86_64", ПутиКМодулямПрограммыКриптоПроНаMacOS());
	
	ПутиКМодулям.Вставить("CryptoPro", Новый ФиксированноеСоответствие(ПутиКриптоПро));
	
КонецПроцедуры

Функция ПутиКМодулямПрограммыКриптоПроНаLinux64()
	
	МодулиПрограммы = Новый Массив;
	МодулиПрограммы.Добавить("/opt/cprocsp/lib/amd64/libcapi10.so");
	МодулиПрограммы.Добавить("/opt/cprocsp/lib/amd64/libcapi20.so");
	
	ПутиКМодулям = Новый Массив;
	ПутиКМодулям.Добавить(СтрСоединить(МодулиПрограммы, ":"));
	Возврат Новый ФиксированныйМассив(ПутиКМодулям);
	
КонецФункции

Функция ПутиКМодулямПрограммыКриптоПроНаLinux32()
	
	МодулиПрограммы = Новый Массив;
	МодулиПрограммы.Добавить("/opt/cprocsp/lib/ia32/libcapi10.so");
	МодулиПрограммы.Добавить("/opt/cprocsp/lib/ia32/libcapi20.so");
	
	ПутиКМодулям = Новый Массив;
	ПутиКМодулям.Добавить(СтрСоединить(МодулиПрограммы, ":"));
	Возврат Новый ФиксированныйМассив(ПутиКМодулям);
	
КонецФункции

Функция ПутиКМодулямПрограммыКриптоПроНаMacOS()
	
	МодулиПрограммы = Новый Массив;
	МодулиПрограммы.Добавить("/opt/cprocsp/lib/libcapi10.dylib");
	МодулиПрограммы.Добавить("/opt/cprocsp/lib/libcapi20.dylib");
	
	ПутиКМодулям = Новый Массив;
	ПутиКМодулям.Добавить(СтрСоединить(МодулиПрограммы, ":"));
	Возврат Новый ФиксированныйМассив(ПутиКМодулям);
	
КонецФункции

#Область ОбновлениеИнформационнойБазы

Процедура ОбновитьВстроенныйКриптопровайдер(Отложенно = Ложь, ОбъектовОбработано = 0, ПроблемныхОбъектов = 0) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПрограммыЭлектроннойПодписиИШифрования.Ссылка КАК Ссылка,
	|	ПрограммыЭлектроннойПодписиИШифрования.Наименование КАК Наименование,
	|	ПрограммыЭлектроннойПодписиИШифрования.ПометкаУдаления КАК ПометкаУдаления
	|ИЗ
	|	Справочник.ПрограммыЭлектроннойПодписиИШифрования КАК ПрограммыЭлектроннойПодписиИШифрования
	|ГДЕ
	|	ПрограммыЭлектроннойПодписиИШифрования.ЭтоВстроенныйКриптопровайдер";
	
	Блокировка = Новый БлокировкаДанных;
	Блокировка.Добавить("Справочник.ПрограммыЭлектроннойПодписиИШифрования");
	
	Представление = НСтр("ru = 'Встроенный криптопровайдер';
						|en = 'Built-in cryptographic service provider'");
	
	НачатьТранзакцию();
	Попытка
		Блокировка.Заблокировать();
		
		Выборка = Запрос.Выполнить().Выбрать();
		ВстроенныйКриптопровайдер = ?(Выборка.Следующий(), Выборка, Неопределено);
		
		Если ВстроенныйКриптопровайдер = Неопределено
		 Или ВстроенныйКриптопровайдер.Наименование <> Представление
		 Или ВстроенныйКриптопровайдер.ПометкаУдаления Тогда
			
			Если ВстроенныйКриптопровайдер = Неопределено Тогда
				Программа = Справочники.ПрограммыЭлектроннойПодписиИШифрования.СоздатьЭлемент();
			Иначе
				Программа = ВстроенныйКриптопровайдер.Ссылка.ПолучитьОбъект();
			КонецЕсли;
			
			Программа.Наименование = Представление;
			Программа.ЭтоВстроенныйКриптопровайдер = Истина;
			ОбновлениеИнформационнойБазы.ЗаписатьОбъект(Программа);
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		
		Если ВстроенныйКриптопровайдер <> Неопределено Тогда
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось обновить программу ""%1"" по причине:
				|%2';
				|en = 'Couldn''t update ""%1"". Reason:
				|%2'"), Строка(Программа), ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			Если Отложенно Тогда
				ПроблемныхОбъектов = ПроблемныхОбъектов + 1;
				
				ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
					УровеньЖурналаРегистрации.Предупреждение, , , ТекстСообщения);
				Возврат;
			КонецЕсли;
		Иначе
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось добавить программу ""%1"" по причине:
				|%2';
				|en = 'Couldn''t add ""%1"". Reason:
				|%2'"), Представление, ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		КонецЕсли;
		ВызватьИсключение ТекстСообщения;
	КонецПопытки;
	
	Если Отложенно И ВстроенныйКриптопровайдер <> Неопределено Тогда
		ОбъектовОбработано = ОбъектовОбработано + 1;
		ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(ВстроенныйКриптопровайдер.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

// Обработчик обновления для перехода на версию 3.1.6.69
Процедура ОбновитьНаименованиеВстроенногоКриптопровайдера() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПрограммыЭлектроннойПодписиИШифрования.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ПрограммыЭлектроннойПодписиИШифрования КАК ПрограммыЭлектроннойПодписиИШифрования
	|ГДЕ
	|	ПрограммыЭлектроннойПодписиИШифрования.ЭтоВстроенныйКриптопровайдер
	|	И ПрограммыЭлектроннойПодписиИШифрования.Наименование = &Наименование";
	
	Запрос.УстановитьПараметр("Наименование", НСтр("ru = 'Облачный сервис';
													|en = 'Cloud service'"));
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Программа = Выборка.Ссылка.ПолучитьОбъект(); // СправочникОбъект.ПрограммыЭлектроннойПодписиИШифрования.
		ЗаблокироватьДанныеДляРедактирования(Выборка.Ссылка);
		Программа.Наименование = НСтр("ru = 'Встроенный криптопровайдер';
										|en = 'Built-in cryptographic service provider'", ОбщегоНазначения.КодОсновногоЯзыка());
		ОбновлениеИнформационнойБазы.ЗаписатьОбъект(Программа);
	КонецЦикла;
	
КонецПроцедуры

Функция АдресаСерверовМетокВремениДляНачальногоЗаполнения() Экспорт

	ЗначениеКонстанты = Константы.АдресаСерверовМетокВремени.Получить();
	
	Если Не ЗначениеЗаполнено(ЗначениеКонстанты)
		Или ЗначениеКонстанты = "https://1stdss.1c.ru/TSP/tsp.srf" Тогда

		МассивАдресов = Новый Массив;
		МассивАдресов.Добавить("http://dss.1stdss.1c.ru/TSP/tsp.srf");
		МассивАдресов.Добавить("http://uc.nalog.ru/tsp/tsp.srf");
		Возврат СтрСоединить(МассивАдресов, Символы.ПС);
		
	КонецЕсли;
	
	Возврат "";
	
КонецФункции

#КонецОбласти

#Область Локализация

Функция ПредставленияСвойствСубъектаСертификата() Экспорт
	
	ПредставленияСвойств = Новый Соответствие;
	ПредставленияСвойств["Должность"] = НСтр("ru = 'Должность';
											|en = 'Job title'");
	ПредставленияСвойств["ОГРН"] = НСтр("ru = 'ОГРН';
										|en = 'OGRN'");
	ПредставленияСвойств["ОГРНИП"] = НСтр("ru = 'ОГРНИП';
											|en = 'OGRNIP'");
	ПредставленияСвойств["СНИЛС"] = НСтр("ru = 'СНИЛС';
										|en = 'SNILS'");
	ПредставленияСвойств["ИНН"] = НСтр("ru = 'ИНН';
										|en = 'TIN'");
	ПредставленияСвойств["ИННЮЛ"] = НСтр("ru = 'ИНН ЮЛ';
										|en = 'Legal entity''s TIN'");
	ПредставленияСвойств["Фамилия"] = НСтр("ru = 'Фамилия';
											|en = 'LastName'");
	ПредставленияСвойств["Имя"] = НСтр("ru = 'Имя';
										|en = 'Name'");
	ПредставленияСвойств["Отчество"] = НСтр("ru = 'Отчество';
											|en = 'Middle name'");
	Возврат ПредставленияСвойств;
	
КонецФункции

Функция ПредставленияСвойствИздателяСертификата() Экспорт
	
	ПредставленияСвойств = Новый Соответствие;
	ПредставленияСвойств["ОГРН"] = НСтр("ru = 'ОГРН';
										|en = 'OGRN'");
	ПредставленияСвойств["ИНН"] = НСтр("ru = 'ИНН';
										|en = 'TIN'");
	ПредставленияСвойств["ИННЮЛ"] = НСтр("ru = 'ИНН ЮЛ';
										|en = 'Legal entity''s TIN'");
	Возврат ПредставленияСвойств;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
