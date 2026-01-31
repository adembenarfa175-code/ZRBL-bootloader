#include <adwaita.h>
#include <gtk/gtk.h>
#include <stdlib.h>

static void on_install_clicked(GtkButton *button, gpointer user_data) {
    g_print("Starting ZRBL Build Process...\n");
    system("./zrbl-build.sh");
}

static void activate(GtkApplication *app, gpointer user_data) {
    GtkWidget *window = adw_application_window_new(app);
    // تصحيح: استخدام دالة GTK القياسية للعنوان
    gtk_window_set_title(GTK_WINDOW(window), "ZRBL Installer v2026.1.0.0");
    gtk_window_set_default_size(GTK_WINDOW(window), 600, 400);

    GtkWidget *view_title = adw_toolbar_view_new();
    GtkWidget *header_bar = adw_header_bar_new();
    adw_toolbar_view_add_top_bar(ADW_TOOLBAR_VIEW(view_title), header_bar);

    GtkWidget *clamp = adw_clamp_new();
    GtkWidget *box = gtk_box_new(GTK_ORIENTATION_VERTICAL, 20);
    gtk_widget_set_margin_top(box, 30);

    GtkWidget *label = gtk_label_new("Welcome to ZRBL Revolution\nArchitecture: x86_64 / ARM64");
    gtk_box_append(GTK_BOX(box), label);

    GtkWidget *install_btn = gtk_button_new_with_label("Start Build & Install");
    // تصحيح: استخدام الطريقة الحديثة بدلاً من الماركات المحذوفة
    gtk_widget_add_css_class(install_btn, "suggested-action");
    
    g_signal_connect(install_btn, "clicked", G_CALLBACK(on_install_clicked), NULL);
    
    gtk_box_append(GTK_BOX(box), install_btn);
    adw_clamp_set_child(ADW_CLAMP(clamp), box);
    adw_toolbar_view_set_content(ADW_TOOLBAR_VIEW(view_title), clamp);
    
    adw_application_window_set_content(ADW_APPLICATION_WINDOW(window), view_title);
    gtk_window_present(GTK_WINDOW(window));
}

int main(int argc, char *argv[]) {
    g_autoptr(AdwApplication) app = adw_application_new("org.zrbl.installer", G_APPLICATION_DEFAULT_FLAGS);
    g_signal_connect(app, "activate", G_CALLBACK(activate), NULL);
    return g_application_run(G_APPLICATION(app), argc, argv);
}
