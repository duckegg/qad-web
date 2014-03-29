package hpps.qad.app.sample.stock;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * @author Leo Liao, 14-2-27, created
 * @version 1.0
 */
@Entity
@Table(name = "STOCK")
public class Stock {
    @Id
    @Column(name = "SYMBOL", length = 50)
    private String symbol;
    @Column(name = "NAME", length = 200)
    private String name;
    @Column(name="PE_RATIO")
    private float peRatio;

    public float getPeRatio() {
        return peRatio;
    }

    public void setPeRatio(float peRatio) {
        this.peRatio = peRatio;
    }

    public String getSymbol() {
        return symbol;
    }

    public void setSymbol(String symbol) {
        this.symbol = symbol;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}
