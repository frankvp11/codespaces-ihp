module Web.View.Static.Welcome where
import Web.View.Prelude

data WelcomeView = WelcomeView

instance View WelcomeView where
    html WelcomeView = [hsx|
         <div style="background-color: #657b83; padding: 2rem; color:hsla(196, 13%, 96%, 1); border-radius: 4px">
            <a href={NewSessionAction}>Login</a>
            <a class="js-delete js-delete-no-confirm" href={DeleteSessionAction}>Logout</a>

        </div> 
|]