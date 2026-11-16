package bj.azo.model;

import java.time.Instant;

/**
 * Ligne de la table {@code "Mission"} (schéma PostgreSQL partagé avec Prisma).
 */
public class Mission {

    /** Libellés d'affichage des statuts de mission. */
    public static String statusLabel(String status) {
        if (status == null) {
            return "—";
        }
        return switch (status) {
            case "PENDING" -> "En attente";
            case "QUOTED" -> "Devis envoyé";
            case "ACCEPTED" -> "Acceptée";
            case "IN_PROGRESS" -> "En cours";
            case "COMPLETED" -> "Terminée";
            case "CANCELLED" -> "Annulée";
            default -> status;
        };
    }

    /** Classe CSS de la pastille de statut. */
    public static String statusPill(String status) {
        if (status == null) {
            return "pill-sand";
        }
        return switch (status) {
            case "COMPLETED" -> "pill-green";
            case "ACCEPTED", "IN_PROGRESS" -> "pill-gold";
            case "CANCELLED" -> "pill-danger";
            default -> "pill-sand";
        };
    }

    private String id;
    private String title;
    private String description;
    private String trade;
    private String city;
    private String district;
    private String status;
    private Integer budget;
    private Integer quoteAmount;
    private Instant scheduledFor;
    private Instant createdAt;
    private String clientName;
    private String workerName;

    /** Libellé d'affichage du statut de cette mission. */
    public String getStatusLabel() {
        return statusLabel(status);
    }

    /** Classe CSS de la pastille de statut de cette mission. */
    public String getStatusPill() {
        return statusPill(status);
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getTrade() {
        return trade;
    }

    public void setTrade(String trade) {
        this.trade = trade;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getDistrict() {
        return district;
    }

    public void setDistrict(String district) {
        this.district = district;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Integer getBudget() {
        return budget;
    }

    public void setBudget(Integer budget) {
        this.budget = budget;
    }

    public Integer getQuoteAmount() {
        return quoteAmount;
    }

    public void setQuoteAmount(Integer quoteAmount) {
        this.quoteAmount = quoteAmount;
    }

    public Instant getScheduledFor() {
        return scheduledFor;
    }

    public void setScheduledFor(Instant scheduledFor) {
        this.scheduledFor = scheduledFor;
    }

    public Instant getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Instant createdAt) {
        this.createdAt = createdAt;
    }

    public String getClientName() {
        return clientName;
    }

    public void setClientName(String clientName) {
        this.clientName = clientName;
    }

    public String getWorkerName() {
        return workerName;
    }

    public void setWorkerName(String workerName) {
        this.workerName = workerName;
    }

    /** Affichage « client › ouvrier » selon le profil connecté. */
    public String getCounterpart(String role) {
        if ("WORKER".equals(role)) {
            return clientName;
        }
        return workerName;
    }

    /** Montant à afficher : devis s'il existe, sinon budget. */
    public Integer getAmount() {
        return quoteAmount != null ? quoteAmount : budget;
    }

    /** Date formatée pour l'affichage (sans dépendre de JSTL fmt sur Instant). */
    public java.util.Date getCreatedDate() {
        return createdAt == null ? null : java.util.Date.from(createdAt);
    }

    public java.util.Date getScheduledDate() {
        return scheduledFor == null ? null : java.util.Date.from(scheduledFor);
    }
}
