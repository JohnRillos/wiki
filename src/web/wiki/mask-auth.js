async function authWithEthereumWallet() {
  const who = document.getElementById('mask-auth-urbit-id').value;
  if (!who) {
    alert('You must enter an Urbit ID to use MetaMask login.');
    return;
  }

  const challengeResponse = await fetch('/wiki/~/auth', {
    method: 'GET',
    headers: {
      'Content-Type': 'application/json'
    }
  });
  if (!challengeResponse.ok) {
    throw Error('Unable to initiate wallet login');
  }
  const challenge = await challengeResponse.json().then(json => json.challenge);
  if (!challenge) {
    throw Error('Auth challenge missing!');
  }
  const accounts = await window.ethereum.request({ method: 'eth_requestAccounts' });
  const account = accounts[0];

  const signature = await window.ethereum.request({
    method: 'personal_sign',
    params: [account, challenge],
  });

  const body = {
    who: document.getElementById('mask-auth-urbit-id').value,
    address: account,
    signature: signature,
    secret: challenge,
  };

  const response = await fetch('/wiki/~/auth', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({ ['eth-auth']: body }),
  });

  if (response.ok) {
    location.reload();
  } else {
    alert('Login failed. Please try again.');
  }
}

authWithEthereumWallet();
