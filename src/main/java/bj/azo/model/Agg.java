package bj.azo.model;

/**
 * Agrégat générique (métier ou ville) renvoyé par une requête
 * {@code SELECT ... GROUP BY ...} exécutée en JDBC.
 */
public class Agg {

    private String label;
    private int count;
    private double avgRating;
    private int minRate;

    public String getLabel() {
        return label;
    }

    public void setLabel(String label) {
        this.label = label;
    }

    public int getCount() {
        return count;
    }

    public void setCount(int count) {
        this.count = count;
    }

    public double getAvgRating() {
        return avgRating;
    }

    public void setAvgRating(double avgRating) {
        this.avgRating = avgRating;
    }

    public int getMinRate() {
        return minRate;
    }

    public void setMinRate(int minRate) {
        this.minRate = minRate;
    }
}
