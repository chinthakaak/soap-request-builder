package com.akc.curlws;


import com.eviware.soapui.impl.wsdl.WsdlInterface;
import com.eviware.soapui.impl.wsdl.WsdlOperation;
import com.eviware.soapui.impl.wsdl.WsdlProject;
import com.eviware.soapui.impl.wsdl.support.http.ProxyUtils;
import com.eviware.soapui.impl.wsdl.support.wsdl.WsdlImporter;
import com.eviware.soapui.model.iface.Operation;
import com.eviware.soapui.SoapUI;
import com.eviware.soapui.settings.ProxySettings;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Arrays;
import java.util.Properties;

public class WsdlAnalyzer {
    public static boolean TESTMODE = false;
    public static int URL_START_POSITION;
    public static String REQUESTS_FOLDER="requests";

    public static void main(String[] endpoints) throws Exception {
//        System.out.println("**********************"+SoapUI.getSettings().isSet(ProxySettings.ENABLE_PROXY));
        try {
            Properties properties = new Properties();
            properties.load(new FileInputStream("project.properties"));
            URL_START_POSITION=Integer.parseInt(properties.getProperty("foldertrimindex"));

            for (String endpoint : endpoints){
                WsdlProject project = new WsdlProject();
//                SoapUI.getSettings().clearSetting( ProxySettings.HOST );
//                SoapUI.getSettings().clearSetting(ProxySettings.PORT);
//                SoapUI.getSettings().clearSetting(ProxySettings.ENABLE_PROXY);
//                SoapUI.saveSettings();
//                SoapUI.updateProxyFromSettings();
//
//                SoapUI.getSettings().setString( ProxySettings.HOST, "10.30.1.30" );
//                SoapUI.getSettings().setString( ProxySettings.PORT, "3128" );
//                SoapUI.getSettings().setBoolean(ProxySettings.ENABLE_PROXY,true);
//                SoapUI.saveSettings();
//                SoapUI.updateProxyFromSettings();

                SoapUI.importPreferences(new File("conf/settings.xml"));
//                SoapUI.saveSettings();
                SoapUI.updateProxyFromSettings();

                WsdlInterface[] wsdls = WsdlImporter.importWsdl(project, endpoint+"?wsdl");
                WsdlInterface wsdl = wsdls[0];
//                System.out.println(wsdl.getDefinition());
//                System.out.println(wsdl.getBindingName());
                for (Operation operation : wsdl.getOperationList()) {
                    WsdlOperation op = (WsdlOperation) operation;
//                    System.out.println("OP:"+op.getName());
//                    System.out.println(op.createRequest(true));

//                    System.out.println("Response:");
//                    System.out.println(op.createResponse(true));
                    createRequestFiles(endpoint,op);

                }

            }
            if (!TESTMODE) System.exit(0);



        }catch (Exception e){
            e.printStackTrace();
        }finally {
            if (!TESTMODE) System.exit(0);
        }
    }

    private static void createRequestFiles(String endpoint, WsdlOperation wsdlOperation) throws IOException {
        File serviceFolder=null;
        String[] strArray = endpoint.split("/");

        String[] newArray= Arrays.copyOfRange(strArray,URL_START_POSITION,strArray.length);
        String fileName=newArray[0];
        String serviceFolderStr=newArray[0];

//        System.out.println(Arrays.toString(newArray));

        for(int i=1;i<newArray.length;i++) {
//            if (i == 0) {
//                serviceFolder = new File(REQUESTS_FOLDER + "/"+newArray[0]);
//                serviceFolder.mkdir();
//            }
//            else{
//                fileName+=newArray[i]+".";
//            }

//            serviceFolderStr+="-"+newArray[i];
            serviceFolderStr+=newArray[i];

        }
        serviceFolderStr=serviceFolderStr.replaceAll("[^a-zA-Z0-9]+","");
//        System.out.println("$$$$$$$$$$$$$$$$$$$$"+serviceFolderStr);
        serviceFolder = new File(REQUESTS_FOLDER + "/"+serviceFolderStr);
        serviceFolder.mkdir();

        PrintWriter writer = new PrintWriter(serviceFolder+"/"+wsdlOperation.getName()+"."+"xml", "UTF-8");
        writer.print(wsdlOperation.createRequest(true));
        writer.close();
    }

}
