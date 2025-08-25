import React, { useState, useEffect } from "react";
import Nui from "./utilities/Nui";
import "./index.css";
import { NotificationProvider, useNotifications } from "./NotificationProvider";

const AppContent = () => {
  const { addNotification } = useNotifications();

  useEffect(() => {
    const handleMessage = (event: MessageEvent) => {
      const { type, notification } = event.data;

      if (type === "SHOW_NOTIFICATION" && notification) {
        // Send debug info to F8
        fetch(`https://${GetParentResourceName()}/debugLog`, {
          method: "POST",
          headers: { "Content-Type": "application/json; charset=UTF-8" },
          body: JSON.stringify({
            message: "[NUI] SHOW_NOTIFICATION received",
            data: notification,
          }),
        });

        addNotification(notification);
      }
    };

    window.addEventListener("message", handleMessage);
    return () => window.removeEventListener("message", handleMessage);
  }, [addNotification]);

  return null;
};


function App() {
  const [hidden, setHidden] = useState(true);

  const closePage = () => {
    setHidden(true);
    Nui.send("close", {});
  };

  useEffect(() => {
    const handleKeyDown = (event) => {
      if (event.key === "Escape") closePage();
    };

    const handleMessage = (event) => {
      if (event.data.type === "SHOW_PAGE") {
        setHidden(false);
      } else if (event.data.type === "CLOSE_PAGE") {
        closePage();
      }
    };

    window.addEventListener("keydown", handleKeyDown);
    window.addEventListener("message", handleMessage);

    return () => {
      window.removeEventListener("keydown", handleKeyDown);
      window.removeEventListener("message", handleMessage);
    };
  }, []);

  return (
    <div id="app">
      <NotificationProvider>
        <AppContent />
      </NotificationProvider>
    </div>
  );
}

export default App;
