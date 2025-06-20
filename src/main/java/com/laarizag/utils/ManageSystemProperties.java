package com.laarizag.utils;

public class ManageSystemProperties {

    private ManageSystemProperties() {
        throw new IllegalStateException("Utility class");
    }

    public static String setProp(String nameEnv, String param) {
        System.setProperty(nameEnv, param);
        return "OK";
    }

    public static String getProp(String nameEnv) {
        return System.getProperty(nameEnv);
    }
}