using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class UIManager : MonoBehaviour
{
	public GameObject savePanel;
	public GameObject mainPanel;
	public Button saveButton;
	public GameObject confirmPanel;
	public GameObject overridePanel;

	private bool m_merge = false;
	private bool m_override = false;
	private string m_selectionName = "";
	public void DisplaySelectionMenu ()
	{
		confirmPanel.SetActive(false);
		overridePanel.SetActive(false);
		savePanel.SetActive(true);
	}

	public void OnSaveButtonClicked ()
	{
		m_override = FragManager.Instance.CheckExistingSelection(m_selectionName);
		if (m_override) 
		{
			EnterOverride();
		}
		overridePanel.SetActive(m_override);
		confirmPanel.SetActive(!m_override);
		savePanel.SetActive(false);
	}

	public void OnConfirmButtonClicked ()
	{
		FragManager.Instance.ValidateSelection(m_selectionName);
		ExitMenu();
	}

	public void OnMergeButtonClicked ()
	{
		FragManager.Instance.MergeSelection(m_selectionName);
		ExitMenu();
	}

	public void OnOverrideButtonClicked ()
	{
		FragManager.Instance.ValidateSelection(m_selectionName);
		ExitMenu();
	}

	public void OnCancelButtonClicked ()
	{
		DisplaySelectionMenu();
	}

	public void OnSaveNameChanged ( string _newName )
	{
		m_selectionName = _newName;
		saveButton.interactable = _newName != "";
	}

	public void ExitMenu()
	{
		mainPanel.SetActive(false);
		FragManager.Instance.mouseSelector.SetActive(true);
	}

	public void EnterMenu()
	{
		mainPanel.SetActive(true);
		FragManager.Instance.mouseSelector.SetActive(false);
		DisplaySelectionMenu();
	}

	public void EnterOverride()
	{
		overridePanel.SetActive(m_override);
		FragManager.Instance.DisplayMerge(m_selectionName);
	}

	private void Update ()
	{
		if (FragManager.Instance == null)
			return;

		if (FragManager.Instance.Mode == FragManager.MANAGER_MODE.SELECT)
		{
			if (Input.GetKeyUp(KeyCode.V) && !mainPanel.activeInHierarchy)
			{
				EnterMenu();
			}

			if (Input.GetKeyUp(KeyCode.Escape) && mainPanel.activeInHierarchy)
			{
				ExitMenu();
			}
		}

	}
}
