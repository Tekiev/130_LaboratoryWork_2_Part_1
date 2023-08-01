package DEV130_2_1_Tekiev;

import java.sql.*;
import java.time.LocalDate;

public class Main {
    private static final String url = "jdbc:mysql://localhost:3306/store_on_sofa";
    private static final String user = "root";
    private static final String password = "root";
    private static Connection connection;
    private static Statement statement;
    private static ResultSet resultSet;
    public static void main(String[] args) {
        loadGoodsFromDB();
        getGoodsOfOrder(1);
        getGoodsOfOrder(6);
        getAllOrders();
        newOrder("Иванов Иван Иванович", "(981)800-32-32", "tof@gmail.com", "Кушелевская дор. д. 3", new String[]{"3251616"}, new int[]{1});
        newOrder("Петров Петр", "(933)100-32-32", "petr@yandex.ru", "Обручевых 9",new String[]{"3251617", "3251619"}, new int[]{1, 5});
        getAllOrders();
    }
    public static void loadGoodsFromDB(){       // загрузка списка товаров из БД и вывод его на экран
        try {
            connection = DriverManager.getConnection(url, user, password);
            statement = connection.createStatement();
            resultSet = statement.executeQuery("select * from store_on_sofa.goods;");
            System.out.println("---------------------------Начало списка продуктов базы данных-------------------------");
            while (resultSet.next()){
                System.out.println(new Good(resultSet.getString(1), resultSet.getString(2), resultSet.getString(3) == null ? "": resultSet.getString(3), resultSet.getInt(4), resultSet.getInt(5)));
            }
            System.out.println("---------------------------Конец списка продуктов базы данных-------------------------");
            resultSet.close();
            statement.close();
            connection.close();
        }
        catch (SQLException sqlException){
            System.out.println(sqlException);
        }
    }
    public static void getGoodsOfOrder(int ID){  // загрузка и печать списка наименований товаров заказа с заданным ID
        if (ID > 0) {
            try {
                connection = DriverManager.getConnection(url, user, password);
                statement = connection.createStatement();
                resultSet = statement.executeQuery("select goods.art, name_art, color   from store_on_sofa.goods left join store_on_sofa.posisions on goods.art = art_order where posisions.cod_order = '" + ID + "';");
                System.out.println("Наименование товаров из заказа " + ID + ":");
                while (resultSet.next()) {
                    System.out.printf("%s, Цвет: %s  %n", resultSet.getString(2), resultSet.getString(3) == null ? "" : resultSet.getString(3));
                }
                resultSet.close();
                statement.close();
                connection.close();
            } catch (SQLException sqlException) {
                System.out.println(sqlException);
            }
        }
    }
    public static void newOrder(String name_buyer, String phone_number, String email, String address, String [] arrayArt, int [] arrayValues_order){   // метод регистрирует в БД новый заказ
        int [] arrayPrice = new int[arrayArt.length];
        for (int i = 0; i < arrayArt.length; i++) {
            arrayPrice[i] = findPrice(arrayArt[i]);
        }
        if (name_buyer != null && address != null  && arrayValues_order[0] > 0 ) {
            try {
                connection = DriverManager.getConnection(url, user, password);
                statement = connection.createStatement();
                resultSet = statement.executeQuery("select  count(*) from store_on_sofa.orders;");
                int id = 0;
                while (resultSet.next()) {
                    id = resultSet.getInt(1) + 1;
                }
                String s = "INSERT INTO `store_on_sofa`.`orders` (`data_order`, `name_buyer`, `phone_number`,`email`, `adress`, `status`) VALUES ('" + LocalDate.now() +"','" + name_buyer + "', '" + phone_number + "','" + email + "','" + address +"', 'P');";
                statement.executeUpdate(s);
                for (int i = 0; i < arrayArt.length; i++) {
                    statement.executeUpdate("INSERT INTO `store_on_sofa`.`posisions` (`cod_order`,`art_order`, `price_order`, `values_order`) VALUES ('" + id + " ','"+ arrayArt[i] + "', '" + arrayPrice[i] +"', '" + arrayValues_order[i] +"');");
                }
                statement.close();
                connection.close();
            } catch (SQLException sqlException) {
                System.out.println(sqlException);
            }
        }
    }
    public static int findPrice(String art){  // вспомогательный метод определения текущей каталожной цены товара
        int price = 0;
        try {
            connection = DriverManager.getConnection(url, user, password);
            statement = connection.createStatement();
            resultSet = statement.executeQuery("select goods.price from store_on_sofa.goods  where goods.art = '" + art + "';");
            while (resultSet.next()) {
                price = resultSet.getInt(1);
            }
            resultSet.close();
            statement.close();
            connection.close();
        }
        catch (SQLException sqlException) {
            System.out.println(sqlException);
        }
        return price;
    }

    public static void getAllOrders(){       // вывод всех заказов для проверки работы метода добавления заказов
        try {
            connection = DriverManager.getConnection(url, user, password);
            statement = connection.createStatement();
            resultSet = statement.executeQuery("select orders.id 'Идентификатор заказа', data_order 'Дата создания заказа', name_buyer 'ФИО заказчика', phone_number 'Контактный телефон', email 'Адрес эл. почты', adress 'Адрес доставки', status 'Статус заказа', data_ship 'Дата отгрузки товара', art_order 'Артикул', price_order 'Цена', values_order 'Количество'   from store_on_sofa.orders left join store_on_sofa.posisions on orders.id = cod_order;");
            System.out.println("---------------------------Начало списка заказов базы данных-------------------------");
            while (resultSet.next()){
                System.out.println(resultSet.getInt(1) + " " + resultSet.getString(2) + " " + resultSet.getString(3) + " "  + (resultSet.getString(4) == null ? "": resultSet.getString(4)) + " " + (resultSet.getString(5) == null ? "": resultSet.getString(5)) + " " + resultSet.getString(6) + " " + resultSet.getString(7) + " " + (resultSet.getString(8) == null ? "": resultSet.getString(8)) + " " + resultSet.getString(9) + " " + resultSet.getInt(10) + " " + resultSet.getInt(11)) ;
            }
            System.out.println("---------------------------Конец списка заказов базы данных-------------------------");
            resultSet.close();
            statement.close();
            connection.close();
        }
        catch (SQLException sqlException){
            System.out.println(sqlException);
        }
    }

}
