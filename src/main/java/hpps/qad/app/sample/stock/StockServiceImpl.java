package hpps.qad.app.sample.stock;

import hpps.qad.base.dao.DaoProvider;
import hpps.qad.core.data.CsvImporter;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.io.Reader;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * @author Leo Liao, 14-2-27, created
 * @version 1.0
 */
public class StockServiceImpl implements StockService {
    private static Logger logger = LoggerFactory.getLogger(StockServiceImpl.class);

    @Override
    public int importQuoteFromCsv(Reader csv, boolean tabSeparated, final String symbol) throws IOException {
        CsvImporter.EntityBuilder<StockQuote> builder = new CsvImporter.EntityBuilder<StockQuote>() {
            @Override
            public StockQuote build(List<String> row, Map<String, Integer> columns) {
                StockQuote stockQuote = new StockQuote();
                stockQuote.setSymbol(symbol);
                stockQuote.setOpen(Float.parseFloat(getCellValue(row, "Open", columns)));
                stockQuote.setClose(Float.parseFloat(getCellValue(row, "Close", columns)));
                stockQuote.setHigh(Float.parseFloat(getCellValue(row, "High", columns)));
                stockQuote.setLow(Float.parseFloat(getCellValue(row, "Low", columns)));
                stockQuote.setVolume(Float.parseFloat(getCellValue(row, "Volume", columns)));
                try {
                    stockQuote.setDate(new SimpleDateFormat("yyyy-MM-dd").parse(getCellValue(row, "Date", columns)));
                } catch (ParseException pe) {
                    throw new IllegalArgumentException("Cannot parse field of Date");
                }
                return stockQuote;
            }
        };
        CsvImporter<StockQuote> importer = new CsvImporter<StockQuote>(DaoProvider.instance().getDao(StockQuote.class));
        return importer.importGeneric(csv, tabSeparated, builder);
    }

    @Override
    public int importStockFromCsv(Reader csv, boolean tabSeparated) throws IOException {
        CsvImporter.EntityBuilder<Stock> builder = new CsvImporter.EntityBuilder<Stock>() {
            @Override
            public Stock build(List<String> row, Map<String, Integer> columns) {
                Stock stock = new Stock();
                stock.setSymbol(getCellValue(row, "symbol", columns));
                stock.setName(getCellValue(row, "name", columns));
                stock.setPeRatio(Float.parseFloat(getCellValue(row, "peRatio", columns)));
                return stock;
            }
        };
        CsvImporter<Stock> importer = new CsvImporter<Stock>(DaoProvider.instance().getDao(Stock.class));
        return importer.importGeneric(csv, tabSeparated, builder);
    }

    /**
     * @param row        column value list
     * @param columnName column name
     * @param columns    a column name and index mapping
     * @return column value
     * @throws IllegalArgumentException if any column is not found
     */
    private String getCellValue(List<String> row, String columnName, Map<String, Integer> columns) throws IllegalArgumentException {
        Integer index = columns.get(columnName);
        if (index == null)
            throw new IllegalArgumentException("Cannot find column '" + columnName + "' in " + columns);
        return row.get(index);
    }
}

