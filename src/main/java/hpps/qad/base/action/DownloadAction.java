package hpps.qad.base.action;


import hpps.qad.base.config.AppConfig;
import hpps.qad.base.dao.DaoProvider;
import hpps.qad.core.BaseMod;
import hpps.qad.core.query.QueryMod;
import hpps.qad.core.attachment.Attachment;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.math.NumberUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;

/**
 * Action to download file. The result type can be either file or screen.
 * If result is file, a InputStream will be returned.
 * If result is screen. a File object will be returned.
 * <pre>
 * <action name="download" class="hpps.qad.base.action.DownloadAction">
 *   <result name="file" type="stream">
 *     <param name="contentType">application/octet-stream</param>
 *     <param name="inputName">fileStream</param>
 *     <param name="contentDisposition">attachment;filename="${filenameInISO}"</param>
 *   </result>
 *   <result name="error" type="freemarker">/WEB-INF/pages/commons/util/download-error.ftl</result>
 *   <result name="screen" type="dispatcher">/WEB-INF/pages/commons/util/read-file.jsp</result>
 * </action>
 * </pre>
 *
 * @author Leo Liao, 12-5-28, created
 * @version 1.0
 */
public class DownloadAction extends BasicAction {
    public static final String DOWNLOAD_TYPE_PDF_REPORT = "pdf_report";
    public static final String DOWNLOAD_TYPE_ATTACHMENT = "attach";
    public static final String DOWNLOAD_TYPE_DRILL_REPORT = "drill_report";
    public static final String DOWNLOAD_TYPE_PROVISION_REPORT = "provision_report";
    public static final String DOWNLOAD_TYPE_SA_LOG = "sa_log";
    public static final String DOWNLOAD_TYPE_APP_LOG = "applog";
    public static final String RESULT_FILE = "file";
    public static final String RESULT_SCREEN = "screen";
    private static final Logger logger = LoggerFactory.getLogger(DownloadAction.class);
    private String downloadDir;
    /**
     * Download file id
     */
    private String id;
    /**
     * Download type
     */
    private String type;
    /**
     * Result type. Default is {@link #RESULT_FILE}.
     */
    private String result = RESULT_FILE;
    /**
     * File to be downloaded
     */
    private File file;
    /**
     * Download file stream
     */
    private InputStream fileStream;

    /**
     * @return from what directory to download file
     */
    public String getDownloadDir() {
        return downloadDir;
    }

    /**
     * @param downloadDir sub dir to <code>qad.pdf.saveDir</code>
     */
    public void setDownloadDir(String downloadDir) {
        this.downloadDir = downloadDir;
    }

    public File getFile() {
        return file;
    }

    public InputStream getFileStream() {
        return fileStream;
    }

    /**
     * Default is {@link #RESULT_FILE}
     */
    public String getResult() {
        return result;
    }

    /**
     * Set the result type. Result type. Default is {@link #RESULT_FILE}.
     *
     * @param result {@link #RESULT_FILE}, {@link #RESULT_SCREEN}
     */
    public void setResult(String result) {
        this.result = result;
    }

    /**
     * Specify what file to be downloaded.
     * The file path is internally calculated by id and type.
     * If type is pdf report, id is filename.
     *
     * @param id id of download file
     */
    public void setId(String id) {
        this.id = id;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String execute() throws Exception {
        file = decideDownloadFile(type, id);
        logger.debug("Download file " + file);
        if (file.exists()) {
            fileStream = new FileInputStream(file);
        } else {
            String msg = "File " + file + " does not exist";
            logger.error(msg);
            return ERROR;
        }
        return result;
    }

    private File decideDownloadFile(String type, String id) {
        String filePath;
        if (StringUtils.equalsIgnoreCase(DOWNLOAD_TYPE_DRILL_REPORT, type)) {
            filePath = getPdfFilePath("drill", id);
        } else if (StringUtils.equalsIgnoreCase(DOWNLOAD_TYPE_PROVISION_REPORT, type)) {
            filePath = getPdfFilePath("Provision", id);
        } else if (StringUtils.equalsIgnoreCase(DOWNLOAD_TYPE_PDF_REPORT, type)) {
            filePath = getPdfFilePath(downloadDir, id);
        } else if (StringUtils.equalsIgnoreCase(DOWNLOAD_TYPE_SA_LOG, type)) {
            filePath = decideStreamFilePath(id);
        } else if (StringUtils.equalsIgnoreCase(DOWNLOAD_TYPE_ATTACHMENT, type)) {
            filePath = decideAttachmentPath(id);
        } else if (StringUtils.equalsIgnoreCase(DOWNLOAD_TYPE_APP_LOG, type)) {
            filePath = decideAppLog(id);
        } else {
            String msg = "Download type '" + "' not recognized";
            logger.error(msg);
            throw new IllegalArgumentException(msg);
        }
        return new File(filePath);
    }

    /**
     * Get PDF file path according to filename
     *
     * @param dir      sub dir to download file from
     * @param filename PDF file name
     * @return absolute file path
     */
    private String getPdfFilePath(String dir, String filename) {
        return QueryMod.getConfig().getGeneratedFileDir(dir) + File.separator + filename;
    }

    /**
     * Decide SA stream log file path.
     *
     * @param filename format: qadmwt@Mastercore.cmb.com:120830192210761:168093
     *                 [sa_username]@[ogfs_host]:[timestamp]:[sequence]
     * @return absolute file path of stream log
     */
    private String decideStreamFilePath(String filename) {
        String dir = AppConfig.getInstance().getSAStreamLogDir();
        String[] arrayKeyTimeSeq = StringUtils.split(filename, ":");
        String timestamp = arrayKeyTimeSeq[1];
        dir = StringUtils.replace(dir, "{YYMM}", timestamp.substring(0, 4));
        return dir + File.separator + filename;
    }

    private String decideAttachmentPath(String id) {
        Attachment attach = DaoProvider.instance().getDao(Attachment.class).findById(NumberUtils.toLong(id));
        return attach.getAbsoluteFilePath();
    }

    private String decideAppLog(String filename) {
        String dir = BaseMod.getConfig().getLogDir();
        return dir + File.separator + filename;
    }

    /**
     * Return filename in ISO8859_1. UTF-8 filename (<code>file.getName()</code>) will cause encoding issue.
     * Please see <a href="http://xredleaf.iteye.com/blog/134607">this post</a>
     */
    public String getFilenameInISO() {
        String filename = file.getName();
        try {
            byte[] s = file.getName().getBytes("UTF-8");
            filename = new String(s, "ISO8859_1");
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
        }
        return filename;
    }
}
