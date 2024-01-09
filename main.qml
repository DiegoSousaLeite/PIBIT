// Importação de módulos necessários para a aplicação
import QtQuick 2.15
import CustomControls 1.0
import QtQuick.Window 2.15
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.5

// Definição da janela principal da aplicação
ApplicationWindow {
    width: 1920                              // Largura da janela
    height: 960                              // Altura da janela
    visible: true                            // A janela está visível
    title: qsTr("Car DashBoard")             // Título da janela
    color: "#1E1E1E"                         // Cor de fundo da janela
    visibility: "FullScreen"                 // A janela é exibida em tela cheia

    // Propriedades relacionadas à simulação de um painel de carro
    property int nextSpeed: 0                 // Próxima velocidade a ser alcançada
    property int maxRandomSpeed: 10            // Velocidade máxima aleatória
    property int maxSpeed: 240                 // Velocidade máxima
    property int speed: 0                      // Velocidade atual
    property int accelerationIncrement: 5       // Incremento de aceleração

    // Timer para simular aceleração contínua
    Timer {
        id: accelerationTimer
        interval: 3000                         // Intervalo do timer em milissegundos
        running: true                          // O timer está em execução
        onTriggered: {
            startAcceleration();               // Função chamada quando o timer é acionado
        }
    }

    // Timer para atualizar a velocidade
    Timer {
        id: speedTimer
        interval: 500                          // Intervalo do timer em milissegundos
        running: true                          // O timer está em execução
        onTriggered: {
            updateSpeed();                     // Função chamada quando o timer é acionado
        }
    }

    // Função para iniciar a aceleração
    function startAcceleration() {
        accelerationTimer.restart();          // Reinicia o timer de aceleração
    }

    // Função para atualizar a velocidade
    function updateSpeed() {
        if (accelerationTimer.running) {
            speed += accelerationIncrement;   // Incrementa a velocidade
            if (speed >= maxSpeed) {
                speed = maxSpeed;
                accelerationTimer.stop();      // Para o timer quando atinge a velocidade máxima
            }
        } else {
            nextSpeed = generateRandom();      // Gera uma nova velocidade aleatória
        }
    }

    // Função para gerar uma velocidade aleatória
    function generateRandom() {
        var newSpeed = speed += Math.random() * (maxRandomSpeed + 1);
        return Math.min(newSpeed, maxSpeed);  // Garante que a velocidade não ultrapasse maxSpeed
    }

    // Função para atualizar rótulos de tempo
    function updateTimeLabels() {
        currentTimeLabel.text = Qt.formatDateTime(new Date(), "hh:mm");
        currentDateLabel.text = Qt.formatDateTime(new Date(), "dd/MM/yyyy");
    }

    // Timer para atualizar a velocidade aleatória em intervalos regulares
    Timer {
        repeat: true
        interval: 3000
        running: true
        onTriggered: {
            nextSpeed = generateRandom();
        }
    }

    // Timer para atualizar o rótulo de velocidade em intervalos regulares
    Timer {
        id: speedTimerr
        repeat: true
        interval: 500
        running: true
        onTriggered: {
            speedLabel.text = Math.floor(nextSpeed);
        }
    }

    // Atalho para fechar a aplicação ao pressionar a tecla de saída padrão
    Shortcut {
        sequence: StandardKey.Quit
        context: Qt.ApplicationShortcut
        onActivated: Qt.quit()
    }


    // Componente de imagem principal (dashboard)
    Image {
        id: dashboard
        width: parent.width
        height: parent.height
        anchors.centerIn: parent
        source: "qrc:/assets/Dashboard.svg"

        // Seção superior da tela (Top Bar)
        Image {
            id: topBar
            width: 1357
            height: 115
            source: "qrc:/assets/Vector 70.svg"

            anchors{
                top: parent.top
                topMargin: 26.50
                horizontalCenter: parent.horizontalCenter
            }

            Image {
                id: headLight
                width: 42.5
                height: 38.25
                anchors{
                    top: parent.top
                    topMargin: 10
                    leftMargin: 230
                    left: parent.left
                }

                source: "qrc:/assets/Low beam headlights.svg"
            }

            Label {
                    id: currentTimeLabel
                    text: Qt.formatDateTime(new Date(), "hh:mm")
                    font.pixelSize: 32
                    font.family: "Inter"
                    font.bold: Font.DemiBold
                    color: "#FFFFFF"
                    anchors.top: parent.top
                    anchors.topMargin: 10
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Label {
                    id: currentDateLabel
                    text: Qt.formatDateTime(new Date(), "dd/MM/yyyy")
                    font.pixelSize: 32
                    font.family: "Inter"
                    font.bold: Font.DemiBold
                    color: "#FFFFFF"
                    anchors.right: parent.right
                    anchors.rightMargin: 230
                    anchors.top: parent.top
                    anchors.topMargin: 10
                }
        }



        // Rótulo de velocidade
        Label {
            id: speedLabel
            text: "0"
            font.pixelSize: 134
            font.family: "Inter"
            font.bold: Font.DemiBold
            anchors.top: parent.top
            anchors.topMargin: Math.floor(parent.height * 0.35)
            anchors.horizontalCenter: parent.horizontalCenter
            color: {
                var speedValue = parseInt(text); // Converte o texto para um número inteiro
                if (speedValue <= 60) {
                    return "#01E6DE"; // Azul para velocidades até 60
                } else if (speedValue <= 150) {
                    return "yellow"; // Amarelo para velocidades de 61 a 150
                } else {
                    return "red"; // Vermelho para velocidades acima de 150
                }
            }
        }

        // Rótulo "KM/H"
        Label {
            text: "KM/H"
            font.pixelSize: 46
            font.family: "Inter"
            font.bold: Font.Normal
            anchors.top: speedLabel.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            color: {
                var speedValue = parseInt(speedLabel.text); // Obtém o valor da velocidade do rótulo de velocidade
                if (speedValue <= 60) {
                    return "#01E6DE"; // Azul para velocidades até 60
                } else if (speedValue <= 150) {
                    return "yellow"; // Amarelo para velocidades de 61 a 150
                } else {
                    return "red"; // Vermelho para velocidades acima de 150
                }
            }
        }



        // Rótulo de limite de velocidade
        Rectangle{
            id:speedLimit
            width: 130
            height: 130
            radius: height/2
            color: "#D9D9D9"
            border.color: "#CD0303"
            border.width: 10

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 50

            Label{
                text: "110"
                font.pixelSize: 52
                font.family: "Inter"
                font.bold: Font.Bold
                color: "#171717"
                anchors.centerIn: parent
            }
        }


        // Componente de estrada à esquerda
        Image {
            id: leftRoad
            width: 127
            height: 397
            anchors{
                left: speedLimit.left
                leftMargin: 100
                bottom: parent.bottom
                bottomMargin: 26.50
            }

            source: "qrc:/assets/Vector 2.svg"
        }

        // Seção de informações à esquerda
        RowLayout{
            spacing: 20

            anchors{
                left: parent.left
                leftMargin: 250
                bottom: parent.bottom
                bottomMargin: 26.50 + 65
            }

            RowLayout{
                spacing: 3
                Label{
                    text: "28"
                    font.pixelSize: 32
                    font.family: "Inter"
                    font.bold: Font.Normal
                    font.capitalization: Font.AllUppercase
                    color: "#FFFFFF"
                }

                Label{
                    text: "°C"
                    font.pixelSize: 32
                    font.family: "Inter"
                    font.bold: Font.Normal
                    font.capitalization: Font.AllUppercase
                    opacity: 0.2
                    color: "#FFFFFF"
                }
            }

            RowLayout{
                spacing: 1
                Layout.topMargin: 10
                Rectangle{
                    width: 20
                    height: 15
                    color: "#32D74B"
                }
                Rectangle{
                    width: 20
                    height: 15
                    color: "#32D74B"
                }
                Rectangle{
                    width: 20
                    height: 15
                    color: "#32D74B"
                }
                Rectangle{
                    width: 20
                    height: 15
                    color: "#01E6DC"
                }
                Rectangle{
                    width: 20
                    height: 15
                    color: "#01E6DC"
                }
                Rectangle{
                    width: 20
                    height: 15
                    color: "#01E6DC"
                }
                Rectangle{
                    width: 20
                    height: 15
                    color: "#01E6DC"
                }
            }

            Label{
                text: "257km/h"
                font.pixelSize: 32
                font.family: "Inter"
                font.bold: Font.Normal
                font.capitalization: Font.AllUppercase
                color: "#FFFFFF"
            }
        }

        // Componente de estrada à direita
        Image {
            id: rightRoad
            width: 127
            height: 397
            anchors{
                right: speedLimit.right
                rightMargin: 100
                bottom: parent.bottom
                bottomMargin: 26.50
            }

            source: "qrc:/assets/Vector 1.svg"
        }

       // Seção de informações à direita
        RowLayout{
            spacing: 20
            anchors{
                right: parent.right
                rightMargin: 350
                bottom: parent.bottom
                bottomMargin: 26.50 + 65
            }

            Label{
                text: "Ready"
                font.pixelSize: 32
                font.family: "Inter"
                font.bold: Font.Normal
                font.capitalization: Font.AllUppercase
                color: "#32D74B"
            }

            Label{
                text: "P"
                font.pixelSize: 32
                font.family: "Inter"
                font.bold: Font.Normal
                font.capitalization: Font.AllUppercase
                opacity: 0.2
                color: "#FFFFFF"
            }

            Label{
                text: "R"
                font.pixelSize: 32
                font.family: "Inter"
                font.bold: Font.Normal
                font.capitalization: Font.AllUppercase
                opacity: 0.2
                color: "#FFFFFF"
            }
            Label{
                text: "N"
                font.pixelSize: 32
                font.family: "Inter"
                font.bold: Font.Normal
                font.capitalization: Font.AllUppercase
                opacity: 0.2
                color: "#FFFFFF"
            }
            Label{
                text: "D"
                font.pixelSize: 32
                font.family: "Inter"
                font.bold: Font.Normal
                font.capitalization: Font.AllUppercase

                color: "#FFFFFF"
            }
        }

        // Ícones do lado esquerdo
        Image {
            id:forthLeftIndicator
            width: 72
            height: 62
            anchors{
                left: parent.left
                leftMargin: 175
                bottom: thirdLeftIndicator.top
                bottomMargin: 25
            }
            source: "qrc:/assets/Parking lights.svg"
        }

        Image {
            id:thirdLeftIndicator
            width: 52
            height: 70.2
            anchors{
                left: parent.left
                leftMargin: 145
                bottom: secondLeftIndicator.top
                bottomMargin: 25
            }
            source: "qrc:/assets/Lights.svg"
        }

        Image {
            id:secondLeftIndicator
            width: 51
            height: 51
            anchors{
                left: parent.left
                leftMargin: 125
                bottom: firstLeftIndicator.top
                bottomMargin: 30
            }
            source: "qrc:/assets/Low beam headlights.svg"
        }

        Image {
            id:firstLeftIndicator
            width: 51
            height: 51
            anchors{
                left: parent.left
                leftMargin: 100
                verticalCenter: speedLabel.verticalCenter
            }
            source: "qrc:/assets/Rare fog lights.svg"
        }

        // Ícones do lado direito
        Image {
            id:forthRightIndicator
            width: 56.83
            height: 36.17
            anchors{
                right: parent.right
                rightMargin: 195
                bottom: thirdRightIndicator.top
                bottomMargin: 50
            }
            opacity: 0.4
            source: "qrc:/assets/FourthRightIcon.svg"
        }

        Image {
            id:thirdRightIndicator
            width: 56.83
            height: 36.17
            anchors{
                right: parent.right
                rightMargin: 155
                bottom: secondRightIndicator.top
                bottomMargin: 50
            }
            opacity: 0.4
            source: "qrc:/assets/thirdRightIcon.svg"
        }

        Image {
            id:secondRightIndicator
            width: 56.83
            height: 36.17
            anchors{
                right: parent.right
                rightMargin: 125
                bottom: firstRightIndicator.top
                bottomMargin: 50
            }
            opacity: 0.4
            source: "qrc:/assets/SecondRightIcon.svg"
        }

        Image {
            id:firstRightIndicator
            width: 36
            height: 45
            anchors{
                right: parent.right
                rightMargin: 100
                verticalCenter: speedLabel.verticalCenter
            }
            source: "qrc:/assets/FirstRightIcon.svg"
        }

        // Barra de progresso radial
        RadialBar {
            id:radialBar
            anchors{
                verticalCenter: parent.verticalCenter
                left: parent.left
                leftMargin: parent.width / 6
            }

            width: 338
            height: 338
            penStyle: Qt.RoundCap
            dialType: RadialBar.NoDial
            progressColor: "#01E4E0"
            backgroundColor: "transparent"
            dialWidth: 17
            startAngle: 270
            spanAngle: 3.6 * value
            minValue: 0
            maxValue: 100
            value: 97
            textFont {
                family: "inter"
                italic: false
                bold: Font.Medium
                pixelSize: 60
            }
            showText: false
            suffixText: ""
            textColor: "#FFFFFF"

            ColumnLayout{
                anchors.centerIn: parent
                Label{
                    text: radialBar.value + "%"
                    font.pixelSize: 65
                    font.family: "Inter"
                    font.bold: Font.Normal
                    color: "#FFFFFF"
                    Layout.alignment: Qt.AlignHCenter
                }

                Label{
                    text: "Carga da Bateria"
                    font.pixelSize: 28
                    font.family: "Inter"
                    font.bold: Font.Normal
                    opacity: 0.8
                    color: "#FFFFFF"
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }

        // Layout de coluna para informações adicionais
        ColumnLayout{
            spacing: 40

            anchors{
                verticalCenter: parent.verticalCenter
                right: parent.right
                rightMargin: parent.width / 6
            }

            RowLayout{
                spacing: 30
                Image {
                    width: 90
                    height: 50
                    source: "qrc:/assets/Group 28.svg"
                }

                ColumnLayout{
                    Label{
                        text: "188 KM"
                        font.pixelSize: 30
                        font.family: "Inter"
                        font.bold: Font.Normal
                        opacity: 0.8
                        color: "#FFFFFF"
                    }
                    Label{
                        text: "Distância"
                        font.pixelSize: 20
                        font.family: "Inter"
                        font.bold: Font.Normal
                        opacity: 0.8
                        color: "#FFFFFF"
                    }
                }
            }
            RowLayout{
                spacing: 30
                Image {
                    width: 72
                    height: 78
                    source: "qrc:/assets/fuel.svg"
                }

                ColumnLayout{
                    Label{
                        text: "10 km/l"
                        font.pixelSize: 30
                        font.family: "Inter"
                        font.bold: Font.Normal
                        opacity: 0.8
                        color: "#FFFFFF"
                    }
                    Label{
                        text: "Med. de Combustível"
                        font.pixelSize: 20
                        font.family: "Inter"
                        font.bold: Font.Normal
                        opacity: 0.8
                        color: "#FFFFFF"
                    }
                }
            }
            RowLayout{
                spacing: 30
                Image {
                    width: 78.72
                    height: 78.68
                    source: "qrc:/assets/speedometer.svg"
                }

                ColumnLayout{
                    Label{
                        text: "95 km/h"
                        font.pixelSize: 30
                        font.family: "Inter"
                        font.bold: Font.Normal
                        opacity: 0.8
                        color: "#FFFFFF"
                    }
                    Label{
                        text: "Vel. Média"
                        font.pixelSize: 20
                        font.family: "Inter"
                        font.bold: Font.Normal
                        opacity: 0.8
                        color: "#FFFFFF"
                    }
                }
            }
        }
    }
}
