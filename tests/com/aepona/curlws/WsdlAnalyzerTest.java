package com.aepona.curlws;

import org.junit.Test;

/**
 * Created by ka40215 on 3/3/15.
 */
public class WsdlAnalyzerTest {
    @Test
    public void testMain() throws Exception {
        WsdlAnalyzer.TESTMODE=true;
        WsdlAnalyzer waz = new WsdlAnalyzer();
//        waz.main(new String[]{"http://localhost:8080/merchant-responder/merchantSubscription/v1"});
        waz.main(new String[]{"http://jango:8080/api-responder/consumerManagement/v1"});

    }

}
