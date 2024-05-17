
App = {
    // Inicializamos un objeto vacio de contracts
    contracts: {},

    // Vamos a inicializar la app
    init: async () => {
        console.log('Loaded...');
        await App.loadEthereum();
        await App.loadAccount();
        await App.loadContracts();
        App.render();
        await App.renderTSP();
    },

    // Vamos a verificar si existen wallets integradas
    loadEthereum: async () => {
        if(window.ethereum) {
            // Si existe la wallet la almaceno en web3Provider
            App.web3Provider = window.ethereum;
            // Nos conectamos a la wallet de metamask
            await window.ethereum.request( {method: 'eth_requestAccounts'} );
        } else if (window.web3){
            // Si contiene librerias de web3.js
            web3 = new Web3(window.web3.currentProvider)
        } else {
            console.log('No tienes una Wallet integrada. Instala Metamask y vuelve a intentarlo.')
        }
    },

    // Vamos a crear una funcion que carga el numero de cuenta de la wallet
    loadAccount: async () => {
        const account = await window.ethereum.request( {method: 'eth_requestAccounts'} );
        App.account = account[0];
    },

    // Vamos a interactuar con los smarts contract
    loadContracts: async () => {
        // A travez de peticion Fetch obtenemos los datos del buil/contracts
        const res = await fetch("TSPContract.json");
        const tspContractJSON = await res.json();
        
        // Convertimos en truffle el archivo JSON
        App.contracts.tspsContract = TruffleContract(tspContractJSON);

        // Conectamos ese contrato a Metamask
        App.contracts.tspsContract.setProvider(App.web3Provider);

        // Ahora vamos a utilizar ese contrato desplegado
        App.tspsContract = await App.contracts.tspsContract.deployed();
    },

    // Vamos a enviar los datos guardado en la blockchaim para pasarlos a la vista
    render: () => {
        document.getElementById('account').innerText = App.account
    },
    renderTSP: async () => {
        const tspCounter = await App.tspsContract.tspCounter();
        const tspCounterNumber = tspCounter.toNumber();
        
        let html = '';

        for (let i = 1; i <= tspCounterNumber; i++) {
            const tsp = await App.tspsContract.tsps(i);
            const tspId = tsp[0];
            const tspNombre = tsp[1];
            const tspClase = tsp[2];
            const tspGenero = tsp[3];
            const tspNombreD = tsp[4];
            const tspWalletD = tsp[5];
            const tspDone = tsp[6];
            const tspCreated = tsp[7];
            
            let tspElement = `
                <div class="card color3 rounded-2 mb-2" style="box-shadow: rgba(14, 30, 37, 0.12) 0px 2px 4px 0px, rgba(14, 30, 37, 0.32) 0px 2px 16px 0px;">
                    <div class="card-header ${tspDone ? "color1" : "color5"} text-white d-flex justify-content-between aling-items-center ">
                        <span class="${tspDone ? "text-muted" : "text-white"} "> ${tspDone ? "Tu mascota ha sido castrada-esterilizada, ahora recibiras tus TSP!" : "Tu mascota no se encuntra Castrada-Esterilizada"} </span>
                        <div class="form-check form-switch">
                            <input class="form-check-input" data-id="${tspId}" 
                                   type="checkbox" ${tspDone && "checked"} 
                                   onchange="App.toggleDone(this)"
                            />
                        </div>
                    </div>    
                
                    <div class="card-body text-white">
                        <div class="row">
                            <span> Nombre: ${tspNombre}</span>
                            <span> Clase: ${tspClase}</span>
                            <span> Genero: ${tspGenero}</span>
                            <span> Nombre del Dueño: ${tspNombreD}</span>
                            <span> Wallet del Dueño: ${tspWalletD}</span>
                            <p class="mt-1">Registrado: ${new Date(tspCreated * 1000).toLocaleString()}</p>
                        </div>                      
                    </div>
                </div>

            `;
            html += tspElement;
        }

        document.querySelector('#tsplist').innerHTML = html;
    },

    // Vamos a crear una nueva tarea
    createTSP: async (nombre, clase, genero, nombreD, walletD) => {
        const result = await App.tspsContract.createTSP(nombre, clase, genero, nombreD, walletD, {
            from: App.account
        })
       
    },

    toggleDone: async (element) => {
        const tspId = element.dataset.id;

        await App.tspsContract.toggleDone(tspId, {
            from: App.account
        })

        window.location.reload();
    }

}
