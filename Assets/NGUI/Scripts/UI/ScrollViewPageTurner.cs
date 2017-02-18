using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class ScrollViewPageTurner : MonoBehaviour 
{
	UIScrollView scrollView;
	bool isCheckTurnPage;
	[HideInInspector][SerializeField]
	public float upDuration;
	[HideInInspector][SerializeField]
	public float downDuration;
	[HideInInspector][SerializeField]
	public List<EventDelegate> upPageEvent = new List<EventDelegate>();
	[HideInInspector][SerializeField]
	public List<EventDelegate> downPageEvent = new List<EventDelegate>();
	// Use this for initialization
	void Start () {
		scrollView = GetComponent<UIScrollView>();
		scrollView.onDragStarted = onDragStarted;
		scrollView.onDragFinished = onDragFinished;
		scrollView.onStoppedMoving = onStoppedMoving;
		isCheckTurnPage = false;
	}
	
	void onDragStarted() {
		isCheckTurnPage = true;
		upDuration = 0;
		downDuration = 0;
	}
	
	void onDragFinished() {

		isCheckTurnPage = false;
		if (upDuration >= 0.2f) {
			EventDelegate.Execute(upPageEvent);
		}
		if (downDuration >= 0.2f) {
			EventDelegate.Execute(downPageEvent);;
		}
		upDuration = 0;
		downDuration = 0;
	}
	
	void onStoppedMoving() {
//		Debug.Log("onStoppedMoving");
	}
	
	void Log(string str) {
		Bounds b = scrollView.bounds;
		Vector3 constraint = scrollView.panel.CalculateConstrainOffset(b.min, b.max);
//		Debug.Log(str + " | " + constraint.x + " , " + constraint.y + " , " + constraint.z);
	}
	
	// Update is called once per frame
	void Update () {
		if (isCheckTurnPage) {
			//			Log("Update");
			Bounds b = scrollView.bounds;
			Vector3 constraint = scrollView.panel.CalculateConstrainOffset(b.min, b.max);
			if (constraint.y >= 50) {
				upDuration += Time.deltaTime;
			} else {
				upDuration = 0;
			}
			
			if (constraint.y <= -50) {
				downDuration += Time.deltaTime;
			} else {
				downDuration = 0;
			}
		}
	}
}