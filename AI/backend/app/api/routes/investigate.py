from loguru import logger



from fastapi import APIRouter, HTTPException



from app.ai.reasoning import analyze_investigation

from app.models.schemas import InvestigationResponse, InvestigateRequest

from app.services.insforge_publisher import (

    InsForgeRealtimePublisher,

    investigation_channel,

)

from app.services.investigation import run_investigation



router = APIRouter(tags=["investigation"])





@router.post("/investigate", response_model=InvestigationResponse)

def investigate_cluster(body: InvestigateRequest | None = None) -> InvestigationResponse:

    """Collect Kubernetes evidence and produce an AI-powered diagnosis."""

    request = body or InvestigateRequest()

    publisher = InsForgeRealtimePublisher()

    channel = (

        investigation_channel(request.investigation_id)

        if request.investigation_id

        else None

    )



    def on_progress(step: str) -> None:

        if channel:

            publisher.publish_progress(channel, step)



    try:

        investigation = run_investigation(on_progress=on_progress)

        if channel:

            publisher.publish_progress(channel, "AI Reasoning")

        diagnosis = analyze_investigation(investigation)

        if channel:

            publisher.publish_progress(channel, "Root Cause Found")

        return InvestigationResponse(

            status="success",

            investigation=investigation,

            diagnosis=diagnosis,

        )

    except Exception as exc:

        logger.exception("Investigation failed")

        raise HTTPException(

            status_code=500,

            detail=f"Investigation failed: {exc}",

        ) from exc

    finally:

        publisher.disconnect()


