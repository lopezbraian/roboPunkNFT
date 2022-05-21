import { useEffect, useState } from "react";
import "./App.css";
import MainMint from "./components/MainMint";
import NavBar from "./components/NavBar";

function App() {
  useEffect(() => {}, []);
  const [accounts, setAccounts] = useState([]);
  return (
    <div className="overlay">
      <div className="App">
        <NavBar accounts={accounts} setAccounts={setAccounts} />
        <MainMint accounts={accounts} />
      </div>
      <div className="moving-background" />
    </div>
  );
}

export default App;
