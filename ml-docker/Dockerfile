FROM jupyter/base-notebook

USER root
RUN pip install tensorflow scikit-learn pandas numpy matplotlib seaborn joblib
USER jovyan

CMD ["start-notebook.sh"]
