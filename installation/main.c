#include <gtk/gtk.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>

// Function to handle the installation logic
void start_installation(GtkWidget *widget, gpointer data) {
    g_print("Starting ZRBL Installation...\n");

    // 1. Create /boot/zrbl directory
    // Note: In real scenarios, this requires sudo/root privileges
    if (mkdir("/boot/zrbl", 0777) == -1) {
        g_printerr("Error creating directory or already exists.\n");
    } else {
        g_print("Directory /boot/zrbl created successfully.\n");
    }

    // 2. Logic to copy bootloader files would go here
    // system("cp ./zrbl_bin /boot/zrbl/");

    // 3. Show Success Message
    GtkWidget *dialog = gtk_message_dialog_new(NULL, GTK_DIALOG_MODAL, 
                                               GTK_MESSAGE_INFO, GTK_BUTTONS_OK,
                                               "ZRBL Installed Successfully!\nPlease reboot your PC to activate.");
    gtk_window_present(GTK_WINDOW(dialog));
}

static void activate(GtkApplication *app, gpointer user_data) {
    GtkWidget *window;
    GtkWidget *button;
    GtkWidget *box;
    GtkWidget *label;

    window = gtk_application_window_new(app);
    gtk_window_set_title(GTK_WINDOW(window), "ZRBL Installer v2025.6.2");
    gtk_window_set_default_size(GTK_WINDOW(window), 400, 200);

    box = gtk_box_new(GTK_ORIENTATION_VERTICAL, 10);
    gtk_widget_set_halign(box, GTK_ALIGN_CENTER);
    gtk_widget_set_valign(box, GTK_ALIGN_CENTER);
    gtk_window_set_child(GTK_WINDOW(window), box);

    label = gtk_label_new("Welcome to ZRBL Bootloader Installer");
    gtk_box_append(GTK_BOX(box), label);

    button = gtk_button_new_with_label("Install to /boot/");
    g_signal_connect(button, "clicked", G_CALLBACK(start_installation), NULL);
    gtk_box_append(GTK_BOX(box), button);

    gtk_window_present(GTK_WINDOW(window));
}

int main(int argc, char **argv) {
    GtkApplication *app;
    int status;

    app = gtk_application_new("com.zrbl.installer", G_APPLICATION_DEFAULT_FLAGS);
    g_signal_connect(app, "activate", G_CALLBACK(activate), NULL);
    status = g_application_run(G_APPLICATION(app), argc, argv);
    g_object_unref(app);

    return status;
}

