#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "radialbar.h"

int main(int argc, char *argv[])
{
    // Configuração para suporte a alta DPI no Qt
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    // Instância da aplicação Qt para interface gráfica
    QGuiApplication app(argc, argv);

    // Engine responsável por carregar e executar a interface QML
    QQmlApplicationEngine engine;

    // Registro do tipo "RadialBar" para ser acessível no QML sob o namespace "CustomControls"
    qmlRegisterType<RadialBar>("CustomControls", 1, 0, "RadialBar");

    // URL do arquivo QML que define a interface
    const QUrl url(QStringLiteral("qrc:/main.qml"));

    // Conexão para encerrar a aplicação se a interface não puder ser criada
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
        &app, [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        }, Qt::QueuedConnection);

    // Carrega a interface QML a partir da URL especificada
    engine.load(url);

    // Executa o loop de eventos da aplicação Qt
    return app.exec();
}
