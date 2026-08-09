package com.uni.certimatricula;

import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;

import com.google.android.recaptcha.Recaptcha;
import com.google.android.recaptcha.RecaptchaAction;
import com.google.android.recaptcha.RecaptchaTasksClient;

@CapacitorPlugin(name = "NativeRecaptcha")
public class RecaptchaPlugin extends Plugin {

    private RecaptchaTasksClient recaptchaClient;

    @PluginMethod
    public void initialize(PluginCall call) {

        String siteKey = "6LetH3wtAAAAAOo0dcs5ztHh2QfwwsI8OMizspfF";

        if (siteKey == null || siteKey.isEmpty()) {
            call.reject("Falta siteKey de reCAPTCHA Android");
            return;
        }

        Recaptcha.fetchTaskClient(
                getActivity().getApplication(),
                siteKey
        ).addOnSuccessListener(client -> {

            recaptchaClient = client;

            JSObject result = new JSObject();
            result.put("ready", true);

            call.resolve(result);

        }).addOnFailureListener(error -> {

            call.reject(
                    "No se pudo inicializar reCAPTCHA Android: "
                            + error.getMessage()
            );

        });
    }

    @PluginMethod
    public void execute(PluginCall call) {

        if (recaptchaClient == null) {
            call.reject("reCAPTCHA Android no está inicializado");
            return;
        }

        String action = call.getString("action", "login");

        RecaptchaAction recaptchaAction =
                RecaptchaAction.custom(action);

        recaptchaClient.executeTask(recaptchaAction)
                .addOnSuccessListener(token -> {

                    JSObject result = new JSObject();
                    result.put("token", token);

                    call.resolve(result);

                })
                .addOnFailureListener(error -> {

                    call.reject(
                            "No se pudo generar token reCAPTCHA: "
                                    + error.getMessage()
                    );

                });
    }
}