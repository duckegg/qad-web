package hpps.qad.base.config;

import org.apache.commons.configuration.Configuration;
import org.apache.commons.configuration.ConfigurationException;
import org.apache.commons.configuration.PropertiesConfiguration;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.HashMap;
import java.util.Map;

/**
 * Utility class for reading app configuration.
 *
 * @author agwks, 12-3-28, created
 * @version 1.0
 * TODO: should use modular setting
 */
public class AppConfig {

    public static final String DEFAULT_APP_CONFIG = "appconfig.properties";
    private static Logger logger = LoggerFactory.getLogger(AppConfig.class);
    private static AppConfig instance = null;
    private static long startupTimestamp = System.currentTimeMillis();
    private PropertiesConfiguration appConfig;


    private AppConfig() {
    }

    public static AppConfig getInstance() {
        if (instance == null)
            instance = new AppConfig();
        return instance;
    }

    /**
     * @return App startup timestamp in ms.
     */
    public static long getStartupTimestamp() {
        return startupTimestamp;
    }

    public String getAIXInstallFlowUUID() {
        return getConfig().getProperty("oo.aixinstall").toString();
    }

    public Configuration getConfig() {
        if (appConfig == null) {
            String filename = "";
            try {
                filename = DEFAULT_APP_CONFIG;
                appConfig = new PropertiesConfiguration(filename);
                logger.info(filename + " loaded");
            } catch (ConfigurationException e) {
                logger.error("Cannot load config file " + filename);
                throw new ExceptionInInitializerError(e);
            }
        }
        return appConfig;
    }

    public Map<String, String> getITILInfo() {
        Map<String, String> result = new HashMap<String, String>();
        result.put("username", getConfig().getString("itil.username"));
        result.put("password", getConfig().getString("itil.password"));
        result.put("ip", getConfig().getString("itil.ip"));
        result.put("port", getConfig().getString("itil.port"));
        result.put("endpoint", getConfig().getString("itil.endpoint"));
        return result;
    }

    /**
     * Get log dir
     */
    public String getLogDir() {
        return getConfig().getString("app.log.dir");
    }

//    /**
//     * Get HP OO integration info
//     */
//    public OOCredential getOOCredential() {
//        OOCredential credential = new OOCredential();
//        credential.setProtocol(getConfig().getString("oo.protocol"));
//        credential.setHost(getConfig().getString("oo.host"));
//        credential.setPort(getConfig().getString("oo.port"));
//        credential.setCompression(Boolean.parseBoolean(getConfig().getString("oo.useCompression")));
//        credential.setUser(getConfig().getString("oo.user"));
//        credential.setPassword(getConfig().getString("oo.password"));
//        credential.setKeystore(getConfig().getString("oo.keystore"));
//        credential.setKeystorePass(getConfig().getString("oo.keystorePass"));
//        credential.setListDir(getConfig().getString("oo.listDir"));
//        credential.setRunDir(getConfig().getString("oo.runDir"));
//        return credential;
//    }

    /**
     * Get value using key from properties file
     *
     * @param name key
     * @return value
     */
    public String getPropertiesValueByName(String name) {
        return getConfig().getProperty(name).toString();
    }

    public String getProvisionCheckFlowUUID() {
        return getConfig().getProperty("oo.checkinstall").toString();
    }

    /**
     * Directory to save SA stream log
     *
     * @return absolute path
     */
    public String getSAStreamLogDir() {
        return getConfig().getString("streamlizer.log.dir");
    }

    /**
     * Get CMB SharePoint integration info
     */
    public Map<String, String> getSPInfo() {
        Map<String, String> result = new HashMap<String, String>();
        result.put("username", getConfig().getString("sp.username"));
        result.put("password", getConfig().getString("sp.password"));
        result.put("ip", getConfig().getString("sp.ip"));
        result.put("port", getConfig().getString("sp.port"));
        result.put("url", getConfig().getString("sp.url"));
        return result;
    }

    public String getSyncAIXInstallResultFlowUUID() {
        return getConfig().getProperty("oo.syncresult").toString();
    }

    public Map<String, String> getUcmdbInfo() {
        Map<String, String> result = new HashMap<String, String>();
        result.put("ip", getConfig().getString("ucmdb.ip"));
        result.put("protocol", getConfig().getString("ucmdb.protocol"));
        result.put("port", getConfig().getString("ucmdb.port"));
        result.put("username", getConfig().getString("ucmdb.username"));
        result.put("password", getConfig().getString("ucmdb.password"));
        return result;
    }

    public String getUcmdbWidgetUrl() {
        return getConfig().getString("ucmdb.widget.url");
    }

    /**
     * Get step task mappings for Provision
     */
    public Map<String, String> getStepTaskMappings() {
        Map<String, String> result = new HashMap<String, String>();
        result.put("31", getConfig().getString("provision.was.31"));
        result.put("32", getConfig().getString("provision.was.32"));
        result.put("41", getConfig().getString("provision.was.41"));
        result.put("42", getConfig().getString("provision.was.42"));
        result.put("43", getConfig().getString("provision.was.43"));
        result.put("51", getConfig().getString("provision.was.51"));
        result.put("52", getConfig().getString("provision.was.52"));
        result.put("53", getConfig().getString("provision.was.53"));
        return result;
    }
}