#include <flutter/dart_project.h>
#include <flutter/flutter_view_controller.h>
#include <windows.h>
#include <shellapi.h>  // Pour la gestion des arguments CLI avancés
#include <ShlObj.h>    // Pour les chemins système

#include "flutter_window.h"
#include "utils.h"

// Vérifie les privilèges admin (optionnel)
bool IsRunningAsAdmin() {
    BOOL isAdmin = FALSE;
    PSID adminGroup;

    // Allocate and initialize a SID for the Administrators group
    SID_IDENTIFIER_AUTHORITY NtAuthority = SECURITY_NT_AUTHORITY;
    if (AllocateAndInitializeSid(
            &NtAuthority, 2, SECURITY_BUILTIN_DOMAIN_RID, DOMAIN_ALIAS_RID_ADMINS,
            0, 0, 0, 0, 0, 0, &adminGroup)) {

        if (!CheckTokenMembership(NULL, adminGroup, &isAdmin)) {
            isAdmin = FALSE;
        }
        FreeSid(adminGroup);
    }

    return isAdmin == TRUE;
}

int APIENTRY wWinMain(_In_ HINSTANCE instance, _In_opt_ HINSTANCE prev,
        _In_ wchar_t *command_line, _In_ int show_command) {
// Attach to console when present (e.g., 'flutter run') or create a
// new console when running with a debugger.
if (!::AttachConsole(ATTACH_PARENT_PROCESS) && ::IsDebuggerPresent()) {
CreateAndAttachConsole();
}

// Initialize COM pour les plugins
HRESULT com_result = ::CoInitializeEx(nullptr, COINIT_APARTMENTTHREADED);
if (FAILED(com_result)) {
OutputDebugString(L"COM initialization failed");
return EXIT_FAILURE;
}

// Gestion avancée des arguments de ligne de commande
int argc;
wchar_t** argv = ::CommandLineToArgvW(::GetCommandLineW(), &argc);
if (argv == nullptr) {
OutputDebugString(L"Command line parsing failed");
::CoUninitialize();
return EXIT_FAILURE;
}

flutter::DartProject project(L"data");

// Passage des arguments à Flutter
std::vector<std::string> command_line_arguments;
for (int i = 1; i < argc; i++) {
command_line_arguments.push_back(Utils::WideToUtf8(argv[i]));
}
LocalFree(argv);
project.set_dart_entrypoint_arguments(std::move(command_line_arguments));

// Configuration de la fenêtre
FlutterWindow window(project);
Win32Window::Point origin(10, 10);
Win32Window::Size size(1280, 720);

// Récupération de la taille de l'écran pour un positionnement optimal
RECT screen_rect;
GetClientRect(GetDesktopWindow(), &screen_rect);
int screen_width = screen_rect.right - screen_rect.left;
int screen_height = screen_rect.bottom - screen_rect.top;

// Centrage de la fenêtre
origin.x = (screen_width - size.width) / 2;
origin.y = (screen_height - size.height) / 2;

if (!window.Create(L"abdias", origin, size)) {
::CoUninitialize();
return EXIT_FAILURE;
}

// Configuration supplémentaire de la fenêtre
window.SetQuitOnClose(true);

// Optionnel : Définir l'icône de la fenêtre
HICON hIcon = LoadIcon(instance, IDI_APPLICATION);
if (hIcon) {
HWND hwnd = window.GetHandle();
SendMessage(hwnd, WM_SETICON, ICON_BIG, (LPARAM)hIcon);
SendMessage(hwnd, WM_SETICON, ICON_SMALL, (LPARAM)hIcon);
}

// Boucle de messages principale
::MSG msg;
while (::GetMessage(&msg, nullptr, 0, 0)) {
::TranslateMessage(&msg);
::DispatchMessage(&msg);
}

::CoUninitialize();
return EXIT_SUCCESS;
}