-- Example from https://github.com/shabuhabs/javashop-otel/tree/workshop
DROP TABLE IF EXISTS InstrumentsForSale;
CREATE TABLE IF NOT EXISTS InstrumentsForSale(
   ID              INTEGER  NOT NULL PRIMARY KEY 
  ,Title           VARCHAR(140) NOT NULL
  ,Sub_title       VARCHAR(58) NOT NULL
  ,Price           VARCHAR(12) NOT NULL
  ,Instrument_Type VARCHAR(29) NOT NULL
  ,Condition       VARCHAR(4) NOT NULL
  ,Location        VARCHAR(33) NOT NULL
  ,Post_URL        VARCHAR(114) NOT NULL
  ,Seller_type     VARCHAR(14) NOT NULL
  ,published_date  VARCHAR(14) NOT NULL
);