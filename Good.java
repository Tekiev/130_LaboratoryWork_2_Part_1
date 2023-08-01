package DEV130_2_1_Tekiev;

public class Good {

    private String art;
    private String name_art;
    private String color;
    private int price;
    private int remains;
    public Good(String art, String name_art, String color, int price, int remains) {
        setArt(art);
        setName_art(name_art);
        setColor(color);
        setPrice(price);
        setRemains(remains);
    }
    public Good(String art, String name_art, int price, int remains) {
        setArt(art);
        setName_art(name_art);
        setPrice(price);
        setRemains(remains);
    }
    public String getArt() {
        return art;
    }
    public void setArt(String art) {
        if (art != null && art.length() == 7) {this.art = art;}
    }
    public String getName_art() {
        return name_art;
    }
    public void setName_art(String name_art) {
        if (name_art != null && name_art.length() < 50) {this.name_art = name_art;}
    }
    public String getColor() {
        return color;
    }
    public void setColor(String color) {
        if (color != null && color.length() < 20) {this.color = color;}
    }
    public int getPrice() {
        return price;
    }
    public void setPrice(int price) {
        if (price > 0) {this.price = price;}
    }
    public int getRemains() {return remains;}
    public void setRemains(int remains) {
        if (remains >= 0){this.remains = remains;}
    }

    @Override
    public String toString() {
        return
                "Артикул: " + art  +
                        ", наименование: " + name_art +
                        ", цвет: " + color  +
                        ", цена: " + price +
                        ", остаток на складе: " + remains;
    }

}
