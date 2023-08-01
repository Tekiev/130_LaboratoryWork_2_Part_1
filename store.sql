DROP DATABASE IF EXISTS store_on_sofa;
CREATE DATABASE IF NOT EXISTS store_on_sofa DEFAULT CHARACTER SET utf8mb4;
DROP TABLE IF EXISTS store_on_sofa.goods;
CREATE TABLE IF NOT EXISTS store_on_sofa.goods(
	art CHAR(7) check(length(art)=7) PRIMARY KEY,
    name_art VARCHAR(50) NOT NULL,
    color VARCHAR(20),
    price INTEGER check(price>0),
    remains INTEGER check(remains>=0)
);
DROP TABLE IF EXISTS store_on_sofa.orders;
CREATE TABLE IF NOT EXISTS store_on_sofa.orders(
	id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
    data_order DATE NOT NULL,
    name_buyer VARCHAR(100) NOT NULL,
    phone_number VARCHAR(50),
    email VARCHAR(50),
    adress VARCHAR(200) NOT NULL,
    status CHAR(1) check(status in('P', 'S', 'C')),
    data_ship DATE,
    constraint data_ship_status check (status='P' AND data_ship is null OR status='C' AND data_ship is null OR status='S' AND data_ship is not null)
);
DROP TABLE IF EXISTS store_on_sofa.posisions;
CREATE TABLE IF NOT EXISTS store_on_sofa.posisions (
    cod_order INTEGER NOT NULL,
    art_order CHAR(7) check(length(art_order)=7),
    price_order INTEGER check(price_order>0),
    values_order INTEGER check(values_order>0),
    primary key (cod_order, art_order),
    FOREIGN KEY fk_posisions_orders (cod_order) REFERENCES orders(id) ON DELETE NO ACTION ON UPDATE NO ACTION,
    FOREIGN KEY fk_posisions_art (art_order) REFERENCES goods(art) ON DELETE NO ACTION ON UPDATE NO ACTION
);
INSERT INTO `store_on_sofa`.`goods` (`art`,`name_art`, `color`, `price`,`remains`) VALUES ('3251615','Стол кухонный', 'белый', '8000', '12');
INSERT INTO `store_on_sofa`.`goods` (`art`,`name_art`, `price`,`remains`) VALUES ('3251616','Стол кухонный',  '8000', '15');
INSERT INTO `store_on_sofa`.`goods` (`art`,`name_art`, `color`, `price`,`remains`) VALUES ('3251617','Стол столовый "гусарский"', 'орех', '4000', '10'); -- количество на складе установлено 10 чтобы работала проверка запроса на уменьшение остатка на складе
INSERT INTO `store_on_sofa`.`goods` (`art`,`name_art`, `color`, `price`,`remains`) VALUES ('3251619','Стол столовый с высокой спинкой', 'белый', '3500', '37');
INSERT INTO `store_on_sofa`.`goods` (`art`,`name_art`, `color`, `price`,`remains`) VALUES ('3251620','Стол столовый с высокой спинкой', 'коричневый', '3500', '52');
select art 'Артикул', name_art 'Наименование', color 'Цвет', price 'Цена', remains 'Остаток на складе'   from store_on_sofa.goods;
INSERT INTO `store_on_sofa`.`orders` (`data_order`, `name_buyer`, `phone_number`,`adress`, `status`, `data_ship`) VALUES ('2020.11.20','Сергей Иванов', '(981)123-45-67', 'ул. Веденеева, 20-1-41', 'S', '2020.11.29');
INSERT INTO `store_on_sofa`.`orders` (`data_order`, `name_buyer`, `phone_number`,`adress`, `status`, `data_ship`) VALUES ('2020.11.22','Алексей Комаров', '(921)001-22-33', 'пр. Пархоменко 51-2-123', 'S', '2020.11.29');
INSERT INTO `store_on_sofa`.`orders` (`data_order`, `name_buyer`, `phone_number`,`adress`, `status`) VALUES ('2020.11.28','Ирина Викторова', '(911)009-88-77', 'Тихорецкий пр. 21-21', 'P');
INSERT INTO `store_on_sofa`.`orders` (`data_order`, `name_buyer`, `email`,`adress`, `status`) VALUES ('2020.12.03','Павел Николаев', 'pasha_nick@mail.ru', 'ул. Хлопина 3-88', 'P');
INSERT INTO `store_on_sofa`.`orders` (`data_order`, `name_buyer`, `phone_number`, `email`,`adress`, `status`) VALUES ('2020.12.03','Антонина Васильева', '(931)777-66-55', 'antvas66@gmail.com','пр. Науки, 11-3-9', 'P'); 
INSERT INTO `store_on_sofa`.`orders` (`data_order`, `name_buyer`, `phone_number`, `adress`, `status`) VALUES ('2020.12.10','Ирина Викторова', '(911)009-88-77','Тихорецкий пр. 21-21', 'P');
INSERT INTO `store_on_sofa`.`posisions` (`cod_order`,  `art_order`, `price_order`, `values_order`) VALUES ( '1', '3251616', '7500', '1');
INSERT INTO `store_on_sofa`.`posisions` (`cod_order`,`art_order`, `price_order`, `values_order`) VALUES ('2','3251615', '7500', '1');
INSERT INTO `store_on_sofa`.`posisions` (`cod_order`,`art_order`, `price_order`, `values_order`) VALUES ('3','3251615', '8000', '1');
INSERT INTO `store_on_sofa`.`posisions` (`cod_order`,`art_order`, `price_order`, `values_order`) VALUES ('3','3251617', '4000', '4');
INSERT INTO `store_on_sofa`.`posisions` (`cod_order`,`art_order`, `price_order`, `values_order`) VALUES ('4','3251619', '3500', '2');
INSERT INTO `store_on_sofa`.`posisions` (`cod_order`,`art_order`, `price_order`, `values_order`) VALUES ('5','3251615', '8000', '1'); 
INSERT INTO `store_on_sofa`.`posisions` (`cod_order`, `art_order`, `price_order`, `values_order`) VALUES ('5','3251617', '4000', '4');
INSERT INTO `store_on_sofa`.`posisions` (`cod_order`,`art_order`, `price_order`, `values_order`) VALUES ('6','3251617', '4000', '2');
select orders.id 'Идентификатор заказа', data_order 'Дата создания заказа', name_buyer 'ФИО заказчика', phone_number 'Контактный телефон', email 'Адрес эл. почты', adress 'Адрес доставки', status 'Статус заказа', data_ship 'Дата отгрузки товара', art_order 'Артикул', price_order 'Цена', values_order 'Количество'   from store_on_sofa.orders left join store_on_sofa.posisions on orders.id = cod_order;
select id 'Идентификатор заказа', data_order 'Дата создания заказа', name_buyer 'ФИО заказчика', phone_number 'Контактный телефон', email 'Адрес эл. почты', adress 'Адрес доставки', status 'Статус заказа', data_ship 'Дата отгрузки товара' from store_on_sofa.orders where store_on_sofa.orders.data_order between '2020-11-01' AND '2020-12-31'  ; -- запрос со списком заказов, созданных в ноябре и декабре
select id 'Идентификатор заказа', data_order 'Дата создания заказа', name_buyer 'ФИО заказчика', phone_number 'Контактный телефон', email 'Адрес эл. почты', adress 'Адрес доставки', status 'Статус заказа', data_ship 'Дата отгрузки товара' from store_on_sofa.orders where store_on_sofa.orders.data_ship between '2020-11-01' AND '2020-12-31'; -- запрос со списком заказов, отгруженных в ноябре и декабре
select distinct name_buyer 'ФИО заказчика', phone_number 'Контактный телефон', email 'Адрес эл. почты' from store_on_sofa.orders; -- запрос с выводом списка клиентов, телефоном и почтой
select orders.id 'Идентификатор заказа', art_order 'Артикул', price_order 'Цена', values_order 'Количество' from store_on_sofa.orders left join store_on_sofa.posisions on orders.id = cod_order where orders.id = '3'; -- запрос со списком позиций из заказа с id=3
select goods.art 'Артикул', name_art 'Наименование'   from store_on_sofa.goods left join store_on_sofa.posisions on goods.art = art_order where posisions.cod_order = '3'; -- запрос с названиями товаров, включенных в заказ с id=3
select  orders.id 'Идентификатор заказа', data_order 'Дата создания заказа', name_buyer 'ФИО заказчика', phone_number 'Контактный телефон', email 'Адрес эл. почты', adress 'Адрес доставки', status 'Статус заказа', data_ship 'Дата отгрузки товара', count(*) 'Количество позиций в заказе'  from store_on_sofa.orders left join store_on_sofa.posisions on orders.id = cod_order where orders.status = 'S' group by orders.id ; -- * запрос со списком отгруженных товаров и количеством позиций в каждом из них
select  orders.id 'Идентификатор заказа', data_order 'Дата создания заказа', name_buyer 'ФИО заказчика', phone_number 'Контактный телефон', email 'Адрес эл. почты', adress 'Адрес доставки', status 'Статус заказа', data_ship 'Дата отгрузки товара', count(*) 'Количество позиций в заказе', SUM(price_order) 'Общая стоиомсть заказа'  from store_on_sofa.orders left join store_on_sofa.posisions on orders.id = cod_order where orders.status = 'S' group by orders.id; -- * запрос дополнительно вычисляющий общую стоимость заказа
update store_on_sofa.orders, store_on_sofa.goods, store_on_sofa.posisions  set orders.status = 'S', orders.data_ship = curdate(), goods.remains = goods.remains-posisions.values_order where orders.id = '5' AND  posisions.cod_order = '5'  AND  goods.art = posisions.art_order ; -- запрос меняет статус 5 заказа, фикирует дату отгрузки и уменьшает остаток товара на складе;
select orders.id 'Идентификатор заказа', data_order 'Дата создания заказа', name_buyer 'ФИО заказчика', phone_number 'Контактный телефон', email 'Адрес эл. почты', adress 'Адрес доставки', status 'Статус заказа', data_ship 'Дата отгрузки товара'from store_on_sofa.orders; -- запрос для проверки изменения статуса отгрузки
select art 'Артикул', name_art 'Наименование', color 'Цвет', price 'Цена', remains 'Остаток на складе'   from store_on_sofa.goods; -- запрос для проверки изменения количества товаров на складе