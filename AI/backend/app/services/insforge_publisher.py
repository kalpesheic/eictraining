"""Publish investigation progress to InsForge realtime channels."""

from __future__ import annotations

import socketio
from loguru import logger

from app.core.config import settings

INVESTIGATION_STEPS = (
    "Checking Pods",
    "Reading Logs",
    "Analyzing Events",
    "Inspecting Deployments",
    "Checking Networking",
    "AI Reasoning",
    "Root Cause Found",
)


class InsForgeRealtimePublisher:
    """Socket.IO client for publishing progress to InsForge realtime channels."""

    def __init__(self) -> None:
        self._sio = socketio.Client(reconnection=False)
        self._connected = False
        self._subscribed_channels: set[str] = set()

    @property
    def enabled(self) -> bool:
        return bool(settings.insforge_url and settings.insforge_api_key)

    def connect(self) -> bool:
        if self._connected:
            return True
        if not self.enabled:
            return False
        try:
            self._sio.connect(
                settings.insforge_url.rstrip("/"),
                auth={"apiKey": settings.insforge_api_key},
                transports=["websocket"],
                wait_timeout=10,
            )
            self._connected = True
            return True
        except Exception as exc:
            logger.warning("InsForge realtime connect failed: {}", exc)
            return False

    def _ensure_subscribed(self, channel: str) -> bool:
        if channel in self._subscribed_channels:
            return True
        try:
            response = self._sio.call("realtime:subscribe", {"channel": channel}, timeout=10)
            if response and response.get("ok"):
                self._subscribed_channels.add(channel)
                return True
            logger.warning("InsForge subscribe failed for {}: {}", channel, response)
        except Exception as exc:
            logger.warning("InsForge subscribe error for {}: {}", channel, exc)
        return False

    def publish_progress(self, channel: str, step: str, status: str = "completed") -> None:
        if not channel:
            return
        if not self.connect():
            return
        if not self._ensure_subscribed(channel):
            return
        try:
            self._sio.emit(
                "realtime:publish",
                {
                    "channel": channel,
                    "event": "progress",
                    "payload": {"step": step, "status": status},
                },
            )
        except Exception as exc:
            logger.warning("InsForge publish failed for {}: {}", channel, exc)

    def disconnect(self) -> None:
        if self._connected:
            try:
                self._sio.disconnect()
            except Exception:
                pass
            self._connected = False
            self._subscribed_channels.clear()


def investigation_channel(investigation_id: str) -> str:
    return f"investigation:{investigation_id}"
