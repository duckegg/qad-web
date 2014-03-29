package hpps.qad.app.sample.stock;

import javax.persistence.*;
import java.util.Date;

/**
 * Quote from yahoo
 * http://ichart.finance.yahoo.com/table.csv?s=^dji&a=01&b=1&c=1980&d=02&e=20&f=2014&g=d
 *
 * @author Leo Liao, 14-2-27, created
 * @version 1.0
 */
@Entity
@Table(name = "STOCK_QUOTE")
public class StockQuote {
    @Id
    @Column(name = "ID")
    @GeneratedValue(strategy = GenerationType.TABLE, generator = "mySeqGen")
    @TableGenerator(name = "mySeqGen", table = "ID_SEQUENCES", allocationSize = 10)
    private Long id;
    @Column(name = "SYMBOL")
    private String symbol;
    @Column(name = "OPEN")
    private Float open;
    @Column(name = "CLOSE")
    private Float close;
    @Column(name = "HIGH")
    private Float high;
    @Column(name = "LOW")
    private Float low;
    @Column(name = "VOLUME")
    private Float volume;
    @Column(name = "DATE")
    private Date date;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Float getVolume() {
        return volume;
    }

    public void setVolume(Float volume) {
        this.volume = volume;
    }

    public Float getOpen() {
        return open;
    }

    public void setOpen(Float open) {
        this.open = open;
    }

    public Float getClose() {
        return close;
    }

    public void setClose(Float close) {
        this.close = close;
    }

    public Float getHigh() {
        return high;
    }

    public void setHigh(Float high) {
        this.high = high;
    }

    public Float getLow() {
        return low;
    }

    public void setLow(Float low) {
        this.low = low;
    }

    public String getSymbol() {
        return symbol;
    }

    public void setSymbol(String symbol) {
        this.symbol = symbol;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }
}
