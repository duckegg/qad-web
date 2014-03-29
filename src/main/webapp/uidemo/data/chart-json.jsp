<%@ page import="com.google.gson.Gson" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.*" %>
<%
    String dataType = request.getParameter("type") + "";
    String token = request.getParameter("token") + "";
    Random random = new Random();
    String input = request.getParameter("inputJson");
    String outputJson;
    if (!StringUtils.isBlank(input)) {
        outputJson = input;
    } else {
        List allSeries = new ArrayList();

        long now = System.currentTimeMillis();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        int seriesInPlot = 5;
        int pointInSeries = 10;

//    SimpleDateFormat sdf = new SimpleDateFormat("HH:mm:ss");
        for (int i = 0; i < seriesInPlot; i++) {
            List<Object[]> seriesDataPoints = new ArrayList<Object[]>();
            for (int m = 0; m < pointInSeries; m++) {
                Object[] point = new Object[2];
                Date date = new Date(now - m * 1000);
                point[0] = sdf.format(date);
//            point[0] = now-m*1000*60;
                point[1] = random.nextInt(100);
                seriesDataPoints.add(point);
            }
            Map series = new HashMap();
            String seriesLegendLabel = "S" + i;
            series.put("dataPoints", seriesDataPoints);
            series.put("legendLabel", seriesLegendLabel);
            allSeries.add(series);
        }

        Map<String, List> plotData = new HashMap<String, List>();
        plotData.put("plotData", allSeries);

        Gson gson = new Gson();
        outputJson = gson.toJson(plotData);
    }
%>
<%=outputJson%>
<%--{"plotData":[{"dataPoints":[["2012-09-02",1],["2012-09-03",14],["2012-09-04",3],["2012-09-05",60],["2012-09-06",15],["2012-09-07",185],["2012-09-08",3],["2012-09-09",2],["2012-09-11",1019]],"legendLabel":"TOP20"}]}--%>